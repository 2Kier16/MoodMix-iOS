//
//  JamendoApiClient.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation

/// Swift equivalent of the JamendoApiClient object
enum JamendoApiClient {
    
    // Base URL matching your Kotlin code
    // Note: I've kept v1.0 vs v3.0 consistent with your Repository needs
    static let baseURL = "https://api.jamendo.com/v1.0/"
    
    /// A shared JSONDecoder configured for Jamendo's naming conventions
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        // If you had snake_case in JSON, you could handle it here globally
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    /// Helper to build the final URL components
    static func url(for endpoint: String) -> URL? {
        return URL(string: baseURL + endpoint)
    }
}