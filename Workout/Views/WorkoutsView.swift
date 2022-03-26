//
//  ContentView.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import SwiftUI

struct WorkoutsView: View {
    @Binding var workouts: [Workout]
    @State private var isPresentingNewScrumView = false
    @State private var newWorkoutData = Workout.Data()
    let saveAction: ()->Void
    @Environment(\.scenePhase) private var scenePhase

    
    var body: some View {
        List {
            ForEach($workouts) { $workout in
                if !workout.deleted {
                    NavigationLink(destination: DetailView(workout: $workout)) {
                        CardView(workout: workout)
                    }
                }
            }
        }
        .navigationTitle("Workouts")
        .toolbar {
            Button(action: {
                isPresentingNewScrumView = true
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationView {
                DetailEditView(data: $newWorkoutData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                                newWorkoutData = Workout.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = Workout(data: newWorkoutData)
                                workouts.append(newScrum)
                                isPresentingNewScrumView = false
                                newWorkoutData = Workout.Data()
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView(workouts: .constant(Workout.sampleData), saveAction: {})
    }
}
