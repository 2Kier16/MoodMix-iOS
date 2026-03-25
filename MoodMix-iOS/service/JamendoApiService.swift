//
//  JamendoApiService.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation

/// Swift equivalent to the Retrofit JamendoApiService interface
struct JamendoApiService {
    
    // Default values matching your Kotlin @Query parameters
    private let defaultAudioFormat = "mp32"
    
    /// Constructs the URL for fetching tracks by mood/tags
    /// Equivalent to @GET("tracks/")
    func getTracksURL(clientId: String, tag: String) -> URL? {
        var components = URLComponents(string: JamendoApiClient.baseURL + "tracks/")
        
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "tags", value: tag),
            URLQueryItem(name: "audioformat", value: defaultAudioFormat),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "limit", value: "20")
        ]
        
        return components?.url
    }
}