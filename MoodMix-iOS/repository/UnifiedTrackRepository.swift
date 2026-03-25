//
//  UnifiedTrackRepository.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//
import Foundation
import MediaPlayer // <--- THIS IS THE REQUIRED LINE!

class UnifiedTrackRepository {
    // I updated these names to match your actual file names
    private let localScanner = LocalMusicScanner()
    private let audiusRepo = AudiusRepository()
    private let jamendoRepo = JamendoRepository()

    /// Combines tracks from all sources into one single list for the UI
    func getTracksForMood(mood: String) async -> [UnifiedTrack] {
        
        // 1. Ask the user for permission to access their Apple Music / Local Library
        let status = await MPMediaLibrary.requestAuthorization()
        guard status == .authorized else {
            print("User denied Apple Music access.")
            return []
        }
        
        // 2. Map the UI's Moods to standard music genres
        let targetGenres: [String]
        switch mood.lowercased() {
        case "calm":      targetGenres = ["Classical", "Acoustic", "Ambient", "Jazz", "Chill", "Country"]
        case "energetic": targetGenres = ["Pop", "Dance", "Electronic", "House", "Upbeat"]
        case "sad":       targetGenres = ["Blues", "R&B", "Soul", "Sad"]
        case "happy":     targetGenres = ["Pop", "Happy", "Disco", "Funk"]
        case "angry":     targetGenres = ["Rock", "Metal", "Punk", "Alternative"]
        case "anxious":   targetGenres = ["Lo-Fi", "Instrumental", "Soundtrack", "Focus"]
        default:          targetGenres = ["Pop", "Rock", "HipHop"]
        }
        
        // 3. Search the user's phone for downloaded/synced music
        let query = MPMediaQuery.songs()
        guard let allItems = query.items, !allItems.isEmpty else {
            print("No music found on this device!")
            return []
        }
        
        // 4. Filter the songs by the genres
        var matchedItems = allItems.filter { item in
            guard let itemGenre = item.genre?.lowercased() else { return false }
            return targetGenres.contains { genre in
                itemGenre.contains(genre.lowercased())
            }
        }
        
        // If we didn't find any exact matches, shuffle all songs as a fallback
        if matchedItems.isEmpty {
            matchedItems = allItems
        }
        
        // 5. Shuffle the results and take the first 15 songs
        let selectedItems = matchedItems.shuffled().prefix(15)
        
        // 6. Convert Apple's items into your UnifiedTracks
        var tracks: [UnifiedTrack] = []
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
        
        return tracks
    }
}
