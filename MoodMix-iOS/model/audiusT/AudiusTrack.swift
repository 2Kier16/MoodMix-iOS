//
//  AudiusTrack.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//


import Foundation

struct AudiusTrack: Codable, Equatable {
    let id: String
    let title: String
    let artists: String
    let streamUrl: String
    let artworkUrl: String?
    let duration: Int?

    // Initializer to handle the default nulls from your Kotlin data class
    init(
        id: String,
        title: String,
        artists: String,
        streamUrl: String,
        artworkUrl: String? = nil,
        duration: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.artists = artists
        self.streamUrl = streamUrl
        self.artworkUrl = artworkUrl
        self.duration = duration
    }
}