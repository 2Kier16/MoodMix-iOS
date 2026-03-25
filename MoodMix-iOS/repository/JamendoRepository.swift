//
//  JamendoRepository.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//

import Foundation

class JamendoRepository {
    private let clientId = "YOUR_JAMENDO_CLIENT_ID"
    
    /// Fetches tracks from Jamendo API based on mood
    func fetchTracks(for mood: String) async -> [UnifiedTrack] {
        let encodedMood = mood.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "chill"
        let urlString = "https://api.jamendo.com/v1.0/tracks/?client_id=\(clientId)&format=json&limit=20&fuzzytags=\(encodedMood)"
        
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(JamendoResponse.self, from: data)
            
            return response.results.map { item in
                UnifiedTrack(
                    id: "jamendo_\(item.id)",
                    title: item.name,
                    artist: item.artistName, // Matches your 'artistName'
                    audioUrl: item.audioUrl, // Matches your 'audioUrl'
                    source: .JAMENDO
                )
            }
        } catch {
            print("JamendoRepository: Error fetching tracks - \(error.localizedDescription)")
            return []
        }
    }
}
