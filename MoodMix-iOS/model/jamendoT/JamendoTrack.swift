//
//  JamendoTrack.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//


import Foundation

struct JamendoTrack: Codable {
    let id: String
    let name: String
    let artistName: String
    let audioUrl: String?
    let duration: Int
    let genre: String?

    // Swift's equivalent to GSON's @SerializedName
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artistName = "artist_name"
        case audioUrl = "audio"
        case duration
        case genre
    }

    // Standard initializer to match Kotlin's default values
    init(
        id: String,
        name: String,
        artistName: String,
        audioUrl: String? = nil,
        duration: Int,
        genre: String? = nil
    ) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.audioUrl = audioUrl
        self.duration = duration
        self.genre = genre
    }
}
