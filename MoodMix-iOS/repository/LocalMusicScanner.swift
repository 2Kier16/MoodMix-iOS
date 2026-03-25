//
//  LocalMusicScanner.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation
import MediaPlayer

class LocalMusicScanner {
    
    /// Fetches local tracks from the user's library matching the mood string
    func fetchTracks(for mood: String) async -> [UnifiedTrack] {
        let query = MPMediaQuery.songs()
        // We filter by the mood string (Genre)
        let predicate = MPMediaPropertyPredicate(value: mood, forProperty: MPMediaItemPropertyGenre, comparisonType: .contains)
        query.addFilterPredicate(predicate)
        
        guard let items = query.items else { return [] }
        
        return items.map { item in
            UnifiedTrack(
                id: "local_\(item.persistentID)",
                title: item.title ?? "Unknown Title",
                artist: item.artist ?? "Unknown Artist",
                audioUrl: item.assetURL?.absoluteString,
                source: .LOCAL
            )
        }
    }
}
