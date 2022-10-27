//
//  WorkoutControls.swift
//  Workout
//
//  Created by Liam Ratcliffe on 11/10/2022.
//

import SwiftUI

struct WorkoutControls: View {
    @ObservedObject var workoutTimer: WorkoutTimer
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.2)
            HStack {
                Spacer()
                Button {
                    workoutTimer.skipBackwards()
                } label: {
                    Image(systemName: "arrow.backward.circle")
                        .foregroundColor(.primary)
                        .font(.system(size: 48))
                }
                Spacer()
                Button {
                    workoutTimer.paused ? workoutTimer.playWorkout() : workoutTimer.pauseWorkout()
                } label: {
                    Image(systemName: workoutTimer.paused ? "play.circle" : "pause.circle")
                        .foregroundColor(.primary)
                        .font(.system(size: 48))
                }
                Spacer()
                Button {
                    workoutTimer.skipForwards()
                } label: {
                    Image(systemName: "arrow.forward.circle")
                        .foregroundColor(.primary)
                        .font(.system(size: 48))
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding()
    }
}

struct WorkoutControls_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutControls(workoutTimer: WorkoutTimer())
    }
}
