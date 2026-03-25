//
//  LocalTrack.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//


import Foundation

struct LocalTrack: Codable, Equatable {
    let title: String
    let artist: String
    let moodTag: String
    let audioUrl: String
    
    // Standard initializer to match your Kotlin data class
    init(
        title: String,
        artist: String,
        moodTag: String,
        audioUrl: String
    ) {
        self.title = title
        self.artist = artist
        self.moodTag = moodTag
        self.audioUrl = audioUrl
    }
}