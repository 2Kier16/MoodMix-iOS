//
//  MoodMixViewModel.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation
import Combine

@MainActor
class MoodMixViewModel: ObservableObject {
    private let unifiedTrackRepository: UnifiedTrackRepository

    // MARK: - Published State (Flows in Kotlin)
    @Published var tracks: [UnifiedTrack] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    @Published var selectedMood: String = "Calm 😌"

    init(unifiedTrackRepository: UnifiedTrackRepository) {
        self.unifiedTrackRepository = unifiedTrackRepository
    }

    // MARK: - Actions

    func setMood(_ mood: String) {
        selectedMood = mood
    }
    /// Fetches tracks for the selected mood
    /// Equivalent to loadTracks(context, mood) using async/await
    func loadTracks(for mood: String? = nil) {
        let moodToLoad = mood ?? selectedMood
        
        isLoading = true
        error = nil

        // Task allows us to call async functions from a synchronous context
        Task {
            do {
                let moodMixTracks = await unifiedTrackRepository.getTracksForMood(mood: moodToLoad)
                self.tracks = moodMixTracks
            } catch {
                self.error = "Failed to load tracks: \(error.localizedDescription)"
                self.tracks = []
            }
            
            self.isLoading = false
        }
    }
}
