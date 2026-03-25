//
//  NowPlayingState.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//

import Foundation

struct NowPlayingState: Equatable {
    var isPlaying: Bool = false
    var title: String? = nil
    var artist: String? = nil
    
    // THIS LINE FIXES THE 'EMPTY' ERRORS
    static let empty = NowPlayingState(isPlaying: false, title: nil, artist: nil)
}
