//
//  SourceType.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//
import Foundation

/// Defines the source of the music
enum SourceType: String, Codable {
    case LOCAL
    case JAMENDO
    case AUDIUS
}

/// The unified model for all tracks in the app
struct UnifiedTrack: Identifiable, Equatable, Codable {
    let id: String
    let title: String
    let artist: String
    let audioUrl: String?
    let source: SourceType
    
    // Explicit initializer to ensure it can be constructed easily
    init(id: String, title: String, artist: String, audioUrl: String?, source: SourceType) {
        self.id = id
        self.title = title
        self.artist = artist
        self.audioUrl = audioUrl
        self.source = source
    }
}
