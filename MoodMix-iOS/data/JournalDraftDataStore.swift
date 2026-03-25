//
//  JournalDraftDataStore.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation
import Combine

class JournalDraftDataStore: ObservableObject {
    // Keys equivalent to stringPreferencesKey and booleanPreferencesKey
    private enum Keys {
        static let mood = "draft_mood"
        static let notes = "draft_notes"
        static let trackTitle = "draft_track_title"
        static let trackArtist = "draft_track_artist"
        static let saved = "draft_saved"
    }

    private let defaults = UserDefaults.standard

    // Published properties provide the "Flow" behavior for SwiftUI
    @Published var draftMood: String = ""
    @Published var draftNotes: String = ""
    @Published var draftTrackTitle: String = ""
    @Published var draftTrackArtist: String = ""
    @Published var draftSaved: Bool = true

    init() {
        loadDraft()
    }

    // Load initial values from UserDefaults
    private func loadDraft() {
        draftMood = defaults.string(forKey: Keys.mood) ?? ""
        draftNotes = defaults.string(forKey: Keys.notes) ?? ""
        draftTrackTitle = defaults.string(forKey: Keys.trackTitle) ?? ""
        draftTrackArtist = defaults.string(forKey: Keys.trackArtist) ?? ""
        draftSaved = defaults.object(forKey: Keys.saved) as? Bool ?? true
    }

    // Save individual fields (equivalent to .edit { })
    func saveMood(_ mood: String) {
        defaults.set(mood, forKey: Keys.mood)
        self.draftMood = mood
    }

    func saveNotes(_ notes: String) {
        defaults.set(notes, forKey: Keys.notes)
        self.draftNotes = notes
    }

    func saveTrackInfo(title: String?, artist: String?) {
        let t = title ?? ""
        let a = artist ?? ""
        defaults.set(t, forKey: Keys.trackTitle)
        defaults.set(a, forKey: Keys.trackArtist)
        self.draftTrackTitle = t
        self.draftTrackArtist = a
    }

    func setDraftSaved(_ saved: Bool) {
        defaults.set(saved, forKey: Keys.saved)
        self.draftSaved = saved
    }

    // Clear everything (equivalent to clearDraft)
    func clearDraft() {
        defaults.set("", forKey: Keys.mood)
        defaults.set("", forKey: Keys.notes)
        defaults.set("", forKey: Keys.trackTitle)
        defaults.set("", forKey: Keys.trackArtist)
        defaults.set(true, forKey: Keys.saved)
        
        // Update local published state
        loadDraft()
    }
}