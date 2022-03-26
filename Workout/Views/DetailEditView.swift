//
//  DetailEditView.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import SwiftUI

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.maximumIntegerDigits = 2

    return formatter
}()

struct DetailEditView: View {
    @Binding var data: Workout.Data
    @State private var newComboName = ""
    
    var body: some View {
        Form {
            Section(header: Text("Workout Title")) {
                TextField("Title", text: $data.title)
            }
            Section(header: Text("Workout Info")) {
                Text("Length of Rounds")
                HStack {
                    Slider(value: $data.secondsInRound, in: 5...600, step: 5) {
                        Text("Length")
                    }
                    .accessibilityValue("\(Int(data.secondsInRound)) seconds")
                    Spacer()
                    Text("\(Int(data.secondsInRound)) Seconds")
                        .accessibilityHidden(true)
                }
                Text("Time between Rounds")
                HStack {
                    Slider(value: $data.secondsInRest, in: 5...600, step: 5) {
                        Text("Length")
                    }
                    .accessibilityValue("\(Int(data.secondsInRest)) seconds")
                    Spacer()
                    Text("\(Int(data.secondsInRest)) Seconds")
                        .accessibilityHidden(true)
                }
                Text("Number of Rounds")
                HStack {
                    Slider(value: $data.numberOfRounds, in: 1...24, step: 1) {
                        Text("Length")
                    }
                    .accessibilityValue("\(data.numberOfRounds) round\(data.numberOfRounds > 1 ? "s" : "")")
                    Spacer()
                    Text("\(Int(data.numberOfRounds)) Round\(data.numberOfRounds > 1 ? "s" : "")")
                        .accessibilityHidden(true)
                }
                HStack {
                    Text("Time per Action")
                        .fixedSize()
                    TextField("0.0", value: $data.timePerAction, formatter: formatter)
                        .multilineTextAlignment(.trailing)
                    Text("s")
                }
                HStack {
                    Text("Time between Combos")
                        .fixedSize()
                    TextField("0.0", value: $data.timeBetweenCombos, formatter: formatter)
                        .multilineTextAlignment(.trailing)
                    Text("s")
                }
            }
            Section(header: Text("Combos")) {
                ForEach(data.combos) { combo in
                    Text(combo.name)
                }
                .onDelete { indices in
                    data.combos.remove(atOffsets: indices)
                }
                HStack {
                    TextField("New Combo", text: $newComboName)
                    Button(action: {
                        withAnimation {
                            let combo = Workout.Combo(name: newComboName)
                            data.combos.append(combo)
                            newComboName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add attendee")
                    }
                    .disabled(newComboName.isEmpty)
                }
            }        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(Workout.sampleData[0].data))
    }
}
