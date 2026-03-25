//
//  JournalViewModel.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation
import Combine
import SwiftData

@MainActor
class JournalViewModel: ObservableObject {
    private let repository: JournalRepository
    private let draftStore: JournalDraftDataStore
    private var cancellables = Set<AnyCancellable>()

    @Published var entries: [ReflectionEntry] = []
    
    // Internal state for editing
    @Published private var editingEntry: ReflectionEntry? = nil
    
    // The final state the UI observes
    @Published var draftState = DraftState()

    init(repository: JournalRepository, draftStore: JournalDraftDataStore) {
        self.repository = repository
        self.draftStore = draftStore
        
        setupBindings()
    }

    private func setupBindings() {
        repository.$entries
            .assign(to: &$entries)

        Publishers.CombineLatest4(
            $editingEntry,
            draftStore.$draftMood,
            draftStore.$draftNotes,
            Publishers.CombineLatest(draftStore.$draftTrackTitle, draftStore.$draftTrackArtist)
        )
        .map { editingEntry, mood, notes, trackInfo in
            DraftState(
                id: editingEntry?.id, // This is now safely capturing the String ID
                mood: mood,
                notes: notes,
                trackTitle: trackInfo.0,
                trackArtist: trackInfo.1
            )
        }
        .assign(to: &$draftState)
    }

    // MARK: - Actions

    func saveEntry() {
        let timestamp = editingEntry?.timestamp ?? Int64(Date().timeIntervalSince1970 * 1000)
        
        if let existing = editingEntry {
            // WE ARE EDITING: Update the exact existing entry in the database
            existing.mood = draftState.mood
            existing.notes = draftState.notes
            existing.trackTitle = draftState.trackTitle.isEmpty ? nil : draftState.trackTitle
            existing.trackArtist = draftState.trackArtist.isEmpty ? nil : draftState.trackArtist
            
            repository.upsert(existing)
        } else {
            // WE ARE CREATING: Make a brand new entry
            let entry = ReflectionEntry(
                id: UUID().uuidString,
                mood: draftState.mood,
                notes: draftState.notes,
                trackTitle: draftState.trackTitle.isEmpty ? nil : draftState.trackTitle,
                trackArtist: draftState.trackArtist.isEmpty ? nil : draftState.trackArtist,
                timestamp: timestamp
            )
            repository.upsert(entry)
        }

        clearDraft()
    }

    func loadEntryForEditing(_ entry: ReflectionEntry) {
        editingEntry = entry
        draftStore.saveMood(entry.mood)
        draftStore.saveNotes(entry.notes)
        draftStore.saveTrackInfo(title: entry.trackTitle, artist: entry.trackArtist)
    }

    func deleteEntry(_ entry: ReflectionEntry) {
        repository.delete(entry)
    }

    func saveDraftNotes(_ notes: String) {
        draftStore.saveNotes(notes)
    }

    func clearDraft() {
        editingEntry = nil
        draftStore.clearDraft()
    }
}

// MARK: - Supporting State

struct DraftState {
    var id: String? = nil // Changed from Int? to String?
    var mood: String = ""
    var notes: String = ""
    var trackTitle: String = ""
    var trackArtist: String = ""
}
