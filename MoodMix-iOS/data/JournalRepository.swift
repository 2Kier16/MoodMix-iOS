//
//  JournalRepository.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//
import Foundation
import SwiftData
import SwiftUI // Adds the UI tools
import Combine // Adds the ObservableObject logic

@MainActor
class JournalRepository: ObservableObject {
    
    // The Manager that lets us fetch or save data
    private var context: ModelContext?

    @Published var entries: [ReflectionEntry] = []

    init() {
        // We pull the database context from our shared DataStack
        self.context = DataStack.shared.container.mainContext
        
        // Load the data immediately
        fetchEntries()
    }

    /// Fetches all saved reflection entries
    func fetchEntries() {
        guard let context = context else { return }
        
        let descriptor = FetchDescriptor<ReflectionEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            self.entries = try context.fetch(descriptor)
        } catch {
            print("JournalRepository: Failed to fetch entries: \(error)")
        }
    }

    /// Saves a new entry
    func upsert(_ entry: ReflectionEntry) {
        guard let context = context else { return }
        
        context.insert(entry)
        
        do {
            try context.save()
            fetchEntries()
        } catch {
            print("JournalRepository: Failed to save entry: \(error)")
        }
    }

    /// Deletes an entry
    func delete(_ entry: ReflectionEntry) {
        guard let context = context else { return }
        context.delete(entry)
        
        do {
            try context.save()
            fetchEntries()
        } catch {
            print("JournalRepository: Failed to delete entry: \(error)")
        }
    }
}
