//
//  UnifiedTrackRepository.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//
import Foundation
import MediaPlayer

class UnifiedTrackRepository {
    // I updated these names to match your actual file names
    private let localScanner = LocalMusicScanner()
    private let audiusRepo = AudiusRepository()
    private let jamendoRepo = JamendoRepository()

    /// Combines tracks from all sources into one single list for the UI
    func getTracksForMood(mood: String) async -> [UnifiedTrack] {
        var tracks: [UnifiedTrack] = []
        
        // 1. Ask for Apple Music Permission
        let status = await MPMediaLibrary.requestAuthorization()
        
        if status == .authorized {
            // 2. Map Moods to Genres
            let targetGenres: [String]
            switch mood.lowercased() {
            case "calm":      targetGenres = ["Classical", "Acoustic", "Ambient", "Jazz", "Chill", "Country"]
            case "energetic": targetGenres = ["Pop", "Dance", "Electronic", "House", "Upbeat"]
            case "sad":       targetGenres = ["Blues", "R&B", "Soul", "Sad"]
            case "happy":     targetGenres = ["Pop", "Happy", "Disco", "Funk"]
            case "angry":     targetGenres = ["Rock", "Metal", "Punk", "Alternative"]
            case "anxious":   targetGenres = ["Lo-Fi", "Instrumental", "Soundtrack", "Focus"]
            default:          targetGenres = ["Pop", "Rock"]
            }
            
            // 3. Search Local Music
            if let allItems = MPMediaQuery.songs().items, !allItems.isEmpty {
                var matchedItems = allItems.filter { item in
                    guard let itemGenre = item.genre?.lowercased() else { return false }
                    return targetGenres.contains { genre in
                        itemGenre.contains(genre.lowercased())
                    }
                }
                
                // If no exact match, shuffle whatever they have
                if matchedItems.isEmpty {
                    matchedItems = allItems
                }
                
                let selectedItems = matchedItems.shuffled().prefix(15)
                
                for item in selectedItems {
                    let id = String(item.persistentID)
                    let track = UnifiedTrack(
                        id: id,
                        title: item.title ?? "Unknown Title",
                        artist: item.artist ?? "Unknown Artist",
                        audioUrl: id,
                        source: .LOCAL
                    )
                    tracks.append(track)
                }
            }
        }
        
        // 4. THE FALLBACK FIX!
        // If Apple Music is empty (or denied), fetch from the internet!
        if tracks.isEmpty {
            print("No local music found. Falling back to internet radio (Audius & Jamendo)...")
            
            // Try Audius First using your real command!
            let audiusTracks = await audiusRepo.fetchTracks(for: mood)
            tracks.append(contentsOf: audiusTracks)
            
            // Try Jamendo Second to mix it up
            let jamendoTracks = await jamendoRepo.fetchTracks(for: mood)
            tracks.append(contentsOf: jamendoTracks)
        }
        
        return tracks
    }
}
