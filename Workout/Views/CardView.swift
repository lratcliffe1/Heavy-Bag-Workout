//
//  CardView.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import SwiftUI

struct CardView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workout.title)
                    .accessibilityAddTraits(.isHeader)
                    .font(.headline)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("\((workout.secondsInRound + workout.secondsInRest) * workout.numberOfRounds / 60) min")
                }
                .font(.caption)
                .opacity(0.7)
            }
            Spacer()
            HStack {
                Text("\(workout.numberOfRounds) Rounds")
                    .accessibilityLabel("Number of rounds \(workout.combos.count)")
                Spacer()
                Text("Round: \(workout.secondsInRound) s")
                    .accessibilityLabel("Round length \(workout.secondsInRound) seconds")
                Spacer()
                Text("Rest: \(workout.secondsInRest) s")
                    .accessibilityLabel("Rest length \(workout.secondsInRest) seconds")
            }
            .font(.caption)
        }
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var workout = Workout.sampleData[0]
    static var previews: some View {
        CardView(workout: workout)
            .background(.gray)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
