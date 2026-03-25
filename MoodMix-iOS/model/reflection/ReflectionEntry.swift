//
//  ReflectionEntry.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//


import Foundation
import SwiftData

@Model
final class ReflectionEntry {
    // Use a guaranteed unique String (UUID) so SwiftData never confuses them
    @Attribute(.unique) var id: String
    var mood: String
    var notes: String
    var trackTitle: String?
    var trackArtist: String?
    var timestamp: Int64

    init(id: String = UUID().uuidString, mood: String, notes: String, trackTitle: String? = nil, trackArtist: String? = nil, timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000)) {
        self.id = id
        self.mood = mood
        self.notes = notes
        self.trackTitle = trackTitle
        self.trackArtist = trackArtist
        self.timestamp = timestamp
    }
}
