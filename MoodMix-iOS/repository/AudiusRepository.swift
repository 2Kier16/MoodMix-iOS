//
//  AudiusRepository.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//

import Foundation

class AudiusRepository {
    private let appName = "MoodMix"
    
    /// Fetches trending tracks from Audius based on the selected mood
    func fetchTracks(for mood: String) async -> [UnifiedTrack] {
        // Audius doesn't have a direct "mood" API for trending,
        // so we use the mood string as a search term.
        let encodedMood = mood.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Calm"
        let urlString = "https://discoveryprovider.audius.co/v1/tracks/search?query=\(encodedMood)&app_name=\(appName)"
        
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Parse the top-level JSON object
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataArray = json["data"] as? [[String: Any]] else {
                return []
            }
            
            var unifiedTracks: [UnifiedTrack] = []
            
            for item in dataArray {
                // Fixed the 'as?' casting and added the missing 'else' logic
                guard let id = item["id"] as? String,
                      let title = item["title"] as? String,
                      let user = item["user"] as? [String: Any],
                      let artistName = user["handle"] as? String ?? user["name"] as? String else {
                    continue
                }
                
                // Construct the streaming URL for Audius
                let streamUrl = "https://discoveryprovider.audius.co/v1/tracks/\(id)/stream?app_name=\(appName)"
                
                let track = UnifiedTrack(
                    id: "audius_\(id)",
                    title: title,
                    artist: artistName,
                    audioUrl: streamUrl,
                    source: .AUDIUS
                )
                
                unifiedTracks.append(track)
            }
            
            return unifiedTracks
            
        } catch {
            print("AudiusRepository: Error fetching tracks - \(error.localizedDescription)")
            return []
        }
    }
}
