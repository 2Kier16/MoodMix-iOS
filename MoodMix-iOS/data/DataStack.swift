//
//  DataStack.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//

import Foundation
import SwiftData
import SwiftUI // THIS IS THE KEY FIX
import Combine // Adding this as a backup to be 100% sure

@MainActor
class DataStack: ObservableObject {
    // This is the single "Source of Truth" for your database
    static let shared = DataStack()
    
    let container: ModelContainer
    
    init() {
        do {
            // This initializes the database for your Journal entries
            container = try ModelContainer(for: ReflectionEntry.self)
        } catch {
            fatalError("DataStack: Could not initialize ModelContainer: \(error)")
        }
    }
}
