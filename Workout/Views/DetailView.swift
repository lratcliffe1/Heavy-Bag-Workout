//
//  DetailView.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import SwiftUI

struct DetailView: View {
    @Binding var workout: Workout
    
    @State private var data = Workout.Data()
    @State private var isPresentingEditView = false
    
    var body: some View {
        List {
            Section(header: Text("Workout Info")) {
                NavigationLink(destination: WorkoutView(workout: $workout)) {
                    Label("Start Workout", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Round Length", systemImage: "clock")
                    Spacer()
                    Text("\(workout.secondsInRound) seconds")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Break Length", systemImage: "clock")
                    Spacer()
                    Text("\(workout.secondsInRest) seconds")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Round Length", systemImage: "rectangle.portrait")
                    Spacer()
                    Text("\(workout.numberOfRounds) round\(workout.numberOfRounds > 1 ? "s" : "")")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Text("Time per Action")
                    Spacer()
                    Text("\(String(format: "%g", workout.timePerAction)) second\(workout.timePerAction == 1 ? "" : "s")")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Text("Time between Combos")
                    Spacer()
                    Text("\(String(format: "%g", workout.timeBetweenCombos)) second\(workout.timeBetweenCombos == 1 ? "" : "s")")
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text("Combos")) {
                ForEach(workout.combos) { combo in
                    Label(combo.name, systemImage: "cylinder")
                }
            }
            Section(header: Text("")) {
                Button(action: {
                    workout.delete()
                }) {
                    Text("Delete Workout").frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle(workout.title)
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
                data = workout.data
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DetailEditView(data: $data)
                    .navigationTitle(workout.title)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                workout.update(from: data)
                            }
                        }
                    }
            }
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(workout: .constant(Workout.sampleData[0]))
        }
    }
}
