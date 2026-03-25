//
//  UnifiedTrackRepository.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//
import Foundation

class UnifiedTrackRepository {
    // I updated these names to match your actual file names
    private let localScanner = LocalMusicScanner()
    private let audiusRepo = AudiusRepository()
    private let jamendoRepo = JamendoRepository()

    /// Combines tracks from all sources into one single list for the UI
    func getTracksForMood(mood: String) async -> [UnifiedTrack] {
        print("UnifiedTrackRepo: Starting fetch for mood: \(mood)")
        
        // We start all three fetches at once
        async let localTracks = localScanner.fetchTracks(for: mood)
        async let audiusTracks = audiusRepo.fetchTracks(for: mood)
        async let jamendoTracks = jamendoRepo.fetchTracks(for: mood)

        // Combine them into one big array
        let allTracks = await (localTracks + audiusTracks + jamendoTracks)
        
        print("UnifiedTrackRepo: Fetched \(allTracks.count) total tracks.")
        
        return allTracks.shuffled()
    }
}
