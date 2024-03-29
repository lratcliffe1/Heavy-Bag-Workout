//
//  WorkoutTimer.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import Foundation
import AVFoundation

class WorkoutTimer: ObservableObject {
    @Published var round = ""
    @Published var secondsElapsed = 0
    @Published var secondsRemaining = 0
    @Published var totalSecondsElapsed = 0
    @Published var totalSecondsRemaining = 0
    @Published var comboText = " "
    @Published var workoutComplete = false
    @Published var paused = false
    
    private(set) var secondsInRound: Int
    private(set) var secondsInRest: Int
    private(set) var numberOfRounds: Int
    private(set) var combos: [Workout.Combo]
    private(set) var timePerAction: Double
    private(set) var timeBetweenCombos: Double
    
    var roundChangedAction: (() -> Void)?

    private var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var startDate: Date?
    private var overrideRoundStartTime: Int = 0
    
    private var onBreak = false
    private var secondsElapsedForRound: Int = 0
    private var roundIndex: Int = 0
    private var roundText: String {
        return onBreak ? "Break \(roundIndex + 1) of \(numberOfRounds)" : "Round \(roundIndex + 1) of \(numberOfRounds)"
    }
    private var totalSeconds: Int
    
    private var comboLength: Double = 1
    private var comboDate: Date = Date()
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    private let synthesizer = AVSpeechSynthesizer()
    private let skipBuffer = 3

    init(secondsInRound: Int = 0, secondsInRest: Int = 0, numberOfRounds: Int = 0, combos: [Workout.Combo] = [], timePerAction: Double = 0.0, timeBetweenCombos: Double = 0.0) {
        self.secondsInRound = secondsInRound
        self.secondsInRest = secondsInRest
        self.numberOfRounds = numberOfRounds
        self.totalSeconds = (secondsInRound + secondsInRest) * numberOfRounds
        self.combos = combos
        self.timePerAction = timePerAction
        self.timeBetweenCombos = timeBetweenCombos
        secondsRemaining = secondsInRound
        round = roundText
    }
    
    func playPlayer() {
        player.seek(to: .zero)
        player.play()
    }
    
    func startWorkout() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
        }
        catch let error as NSError {
            print("Error: Could not set audio category: \(error), \(error.userInfo)")
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print("Error: Could not setActive to true: \(error), \(error.userInfo)")
        }
        
        playPlayer()
        changeRound(at: 0)
    }
    
    func stopWorkout() {
        timer?.invalidate()
        timer = nil
        timerStopped = true
    }

    private func changeRound(at index: Int) {
        secondsElapsedForRound = overrideRoundStartTime
        guard index < numberOfRounds else { return }
        roundIndex = index
        round = roundText

        startDate = Date().addingTimeInterval(Double(-overrideRoundStartTime))
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            if let self = self, let startDate = self.startDate {
                let secondsElapsed = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                self.update(secondsElapsed: Int(secondsElapsed))
            }
        }
    }

    private func update(secondsElapsed: Int) {
        secondsElapsedForRound = secondsElapsed
        self.secondsElapsed = secondsElapsedForRound
        self.secondsRemaining = onBreak ? secondsInRest - secondsElapsedForRound : secondsInRound - secondsElapsedForRound
        
        let additionalBreakTime = onBreak ? secondsInRound : 0
        self.totalSecondsElapsed = (secondsInRound + secondsInRest) * roundIndex + secondsElapsedForRound + additionalBreakTime
        self.totalSecondsRemaining = totalSeconds - totalSecondsElapsed
        
        secondsRemaining = max((onBreak ? secondsInRest : secondsInRound) - self.secondsElapsed, 0)
        
        let interval = Date().addingTimeInterval(Double(-overrideRoundStartTime)).timeIntervalSince1970 - comboDate.timeIntervalSince1970
        let combo = combos.randomElement()?.name ?? ""
        comboLength = Double(combo.components(separatedBy: .whitespacesAndNewlines).count)
        
        if !onBreak && !paused && interval > Double(timeBetweenCombos + ((comboLength - 1) * timePerAction)) && secondsElapsed != 0 {
            comboText = combo
            comboDate = Date()
            let utterance = AVSpeechUtterance(string: combo)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")

            synthesizer.speak(utterance)
        }
        if onBreak {
            comboText = "Break"
        }
        
        overrideRoundStartTime = 0

        guard !timerStopped else { return }
        
        if onBreak && roundIndex == numberOfRounds - 1 && secondsElapsedForRound >= secondsInRest {
            playPlayer()
            workoutComplete = true
            stopWorkout()
        } else {
            if !onBreak && secondsElapsedForRound > secondsInRound {
                onBreak = true
                playPlayer()
                changeRound(at: roundIndex)
                roundChangedAction?()
            }
            if onBreak && secondsElapsedForRound > secondsInRest {
                onBreak = false
                playPlayer()
                changeRound(at: roundIndex + 1)
                roundChangedAction?()
            }
        }
    }
    
    func reset(secondsInRound: Int, secondsInRest: Int, numberOfRounds: Int, combos: [Workout.Combo], timePerAction: Double, timeBetweenCombos: Double) {
        self.secondsInRound = secondsInRound
        self.secondsInRest = secondsInRest
        self.numberOfRounds = numberOfRounds
        self.combos = combos
        self.timePerAction = timePerAction
        self.timeBetweenCombos = timeBetweenCombos
        secondsRemaining = secondsInRound
        totalSecondsRemaining = (secondsInRound + secondsInRest) * numberOfRounds
        totalSeconds = (secondsInRound + secondsInRest) * numberOfRounds
        round = roundText
    }
    
    func pauseWorkout() {
        overrideRoundStartTime = Int(Date().timeIntervalSince1970 - startDate!.timeIntervalSince1970)
        paused = true
        stopWorkout()
    }
    
    func playWorkout() {
        paused = false
        timerStopped = false
        changeRound(at: roundIndex)
    }
    
    func skipBackwards() {
        if onBreak {
            if secondsElapsedForRound < skipBuffer {
                onBreak = false
                comboText = " "
                changeRound(at: roundIndex)
            } else {
                onBreak = true
                comboText = " "
                changeRound(at: roundIndex)
            }
        } else {
            if secondsElapsedForRound < skipBuffer && roundIndex > 0 {
                onBreak = true
                comboText = " "
                roundIndex -= 1
                changeRound(at: roundIndex)
            } else {
                onBreak = false
                comboText = " "
                changeRound(at: roundIndex)
            }
        }
    }
    
    func skipForwards() {
        if onBreak && roundIndex < numberOfRounds - 1 {
            onBreak = false
            comboText = " "
            roundIndex += 1
            changeRound(at: roundIndex)
        } else if !onBreak {
            onBreak = true
            comboText = " "
            changeRound(at: roundIndex)
        }
    }
}

extension Workout {
    var timer: WorkoutTimer {
        WorkoutTimer(secondsInRound: secondsInRound, secondsInRest: secondsInRest, numberOfRounds: numberOfRounds, combos: combos)
    }
}
