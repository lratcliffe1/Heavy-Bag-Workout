//
//  WorkoutApp.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import SwiftUI

@main
struct WorkoutApp: App {
    @StateObject private var store = WorkoutStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WorkoutsView(workouts: $store.workouts) {
                    Task {
                        do {
                            try await WorkoutStore.save(workouts: store.workouts.filter { workout in
                                return !workout.deleted
                              })
                        } catch {
                            
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .task {
                do {
                    store.workouts = try await WorkoutStore.load()
                } catch {
                    
                }
            }
        }
    }
}
