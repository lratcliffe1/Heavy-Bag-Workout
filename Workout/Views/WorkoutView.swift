//
//  MeetingsView.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import SwiftUI
import AVFoundation

struct WorkoutView: View {
    @Binding var workout: Workout
    @StateObject var workoutTimer = WorkoutTimer()
    
    func secondsToMinutesSeconds(_ seconds: Int) -> (String) {
        let minsCalc = seconds / 60
        let secsCalc = (seconds % 3600) % 60
        if minsCalc == 10 {
            return "10:00"
        }
        let mins = "0\(minsCalc > 0 ? minsCalc : 0)"
        let secs = "\(secsCalc > 9 ? "\(secsCalc)" : "0" + "\(secsCalc)")"
        return mins + ":" + secs
    }
    
    var body: some View {
        VStack {
            Circle()
                .strokeBorder(lineWidth: 32)
                .overlay {
                    VStack {
                        if workoutTimer.workoutComplete {
                            Text("Workout")
                                .font(.title)
                            Text("Complete")
                                .font(.largeTitle)
                        } else {
                            Text(workoutTimer.comboText)
                                .font(.title)
                                .padding()
                            Text(secondsToMinutesSeconds(workoutTimer.secondsRemaining))
                                .font(.largeTitle)
                                .padding()
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
                .overlay  {
                    Circle()
                        .trim(from: 0, to: (Double(workoutTimer.secondsElapsed) / (Double(workoutTimer.secondsElapsed) + Double(workoutTimer.secondsRemaining))))
                        .rotation(.degrees(-90))
                        .stroke(Color(UIColor.systemBackground) ,style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .padding()
                }
                .padding(.horizontal)

            Text(workoutTimer.round)
                .font(.title)
            Text("")            
            ProgressView(value: workoutTimer.workoutComplete ? 1.0 : Double(workoutTimer.totalSecondsElapsed) / (Double(workoutTimer.totalSecondsRemaining) + Double(workoutTimer.totalSecondsElapsed)))
                .padding()
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
            workoutTimer.reset(secondsInRound: workout.secondsInRound, secondsInRest: workout.secondsInRest, numberOfRounds: workout.numberOfRounds, combos: workout.combos, timePerAction: workout.timePerAction, timeBetweenCombos: workout.timeBetweenCombos)
            workoutTimer.startWorkout()
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            workoutTimer.stopWorkout()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: .constant(Workout.sampleData[0]))
    }
}
