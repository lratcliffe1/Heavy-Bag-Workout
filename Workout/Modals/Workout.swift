//
//  Workout.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    var title: String
    var combos: [Combo]
    var secondsInRound: Int
    var secondsInRest: Int
    var numberOfRounds: Int
    var timePerAction: Double
    var timeBetweenCombos: Double
    var deleted: Bool
    
    init(id: UUID = UUID(), title: String, combos: [Combo], secondsInRound: Int, secondsInRest: Int, numberOfRounds: Int, timePerAction: Double, timeBetweenCombos: Double, deleted: Bool) {
        self.id = id
        self.title = title
        self.combos = combos
        self.secondsInRound = secondsInRound
        self.secondsInRest = secondsInRest
        self.numberOfRounds = numberOfRounds
        self.timePerAction = timePerAction
        self.timeBetweenCombos = timeBetweenCombos
        self.deleted = deleted
    }
}

extension Workout {
    struct Combo: Identifiable, Codable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {
            self.id = id
            self.name = name
        }
    }
    
    struct Data {
        var title: String = ""
        var combos: [Combo] = []
        var secondsInRound: Double = 180
        var secondsInRest: Double = 60
        var numberOfRounds: Double = 6
        var timePerAction: Double = 0.5
        var timeBetweenCombos: Double = 1.0
        var deleted: Bool = false
    }
    
    var data: Data {
        Data(title: title, combos: combos, secondsInRound: Double(secondsInRound), secondsInRest: Double(secondsInRest), numberOfRounds: Double(numberOfRounds), timePerAction: timePerAction, timeBetweenCombos: timeBetweenCombos, deleted: deleted)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        combos = data.combos
        secondsInRound = Int(data.secondsInRound)
        secondsInRest = Int(data.secondsInRest)
        numberOfRounds = Int(data.numberOfRounds)
        timePerAction = data.timePerAction
        timeBetweenCombos = data.timeBetweenCombos
    }
    
    mutating func delete() {
        deleted = true
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        combos = data.combos
        secondsInRound = Int(data.secondsInRound)
        secondsInRest = Int(data.secondsInRest)
        numberOfRounds = Int(data.numberOfRounds)
        timePerAction = data.timePerAction
        timeBetweenCombos = data.timeBetweenCombos
        deleted = false
    }
}

extension Workout {
    static let sampleData: [Workout] =
    [
        Workout(title: "Kicks", combos: [Combo(name: "Kick")], secondsInRound: 180, secondsInRest: 60, numberOfRounds: 4, timePerAction: 0.5, timeBetweenCombos: 1, deleted: false),
        Workout(title: "Kicks 2", combos: [Combo(name: "Kick"), Combo(name: "Left Kick")], secondsInRound: 60, secondsInRest: 60, numberOfRounds: 8, timePerAction: 0.5, timeBetweenCombos: 1, deleted: false),
    ]
}
