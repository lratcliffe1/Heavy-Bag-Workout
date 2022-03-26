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
            Text(workout.title)
                .accessibilityAddTraits(.isHeader)
                .font(.headline)
            Spacer()
            HStack {
                Text("\(workout.numberOfRounds) Rounds")
                    .accessibilityLabel("\(workout.combos.count) attendees")
                Spacer()
                Text("Round: \(workout.secondsInRound)s")
                    .accessibilityLabel("\(workout.secondsInRound) second rounds")
                Spacer()
                Text("Rest: \(workout.secondsInRest)s")
                    .accessibilityLabel("\(workout.secondsInRest) second rest")
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
