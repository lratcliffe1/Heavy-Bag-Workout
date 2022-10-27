//
//  WorkoutStore.swift
//  Workout
//
//  Created by Liam Ratcliffe on 04/01/2022.
//

import Foundation
import SwiftUI

class WorkoutStore: ObservableObject {
    @Published var workouts: [Workout] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("workouts.data")
    }
    
    static func load() async throws -> [Workout] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let workouts):
                    continuation.resume(returning: workouts)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Workout], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let Workouts = try JSONDecoder().decode([Workout].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(Workouts))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(workouts: [Workout]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(workouts: workouts) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let workoutsSaved):
                    continuation.resume(returning: workoutsSaved)
                }
            }
        }
    }
    
    static func save(workouts: [Workout], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(workouts)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(workouts.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
