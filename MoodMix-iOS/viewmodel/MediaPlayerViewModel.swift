//
//  MediaPlayerViewModel.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class MediaPlayerViewModel: ObservableObject {
    
    // 1. This fixes the "has no member 'shared'" error
    static let shared = MediaPlayerViewModel()
    
    // 2. Variables the UI watches
    @Published var currentTrack: UnifiedTrack?
    @Published var isPlaying: Bool = false
    @Published private(set) var currentIndex: Int = 0
    
    private var playlist: [UnifiedTrack] = []
    var playlistCount: Int { playlist.count }
    
    // Private init ensures we only ever have ONE player running
    private init() {}

    // 3. This fixes the "has no member 'setPlaylist'" error
    func setPlaylist(_ tracks: [UnifiedTrack]) {
        self.playlist = tracks
        self.currentIndex = 0
        if let first = tracks.first {
            self.currentTrack = first
            if let urlString = first.audioUrl, let url = URL(string: urlString) {
                PlaybackManager.shared.updateNowPlaying(title: first.title, artist: first.artist)
                PlaybackManager.shared.play(url: url)
            }
        }
    }

    // 4. This fixes the "has no member 'play'" error
    func play() {
        self.isPlaying = true
        if let urlString = currentTrack?.audioUrl, let url = URL(string: urlString) {
            PlaybackManager.shared.updateNowPlaying(title: currentTrack!.title, artist: currentTrack!.artist)
            PlaybackManager.shared.play(url: url)
        }
    }

    // 5. This fixes the "has no member 'stop'" error
    func stop() {
        PlaybackManager.shared.stop()
        self.isPlaying = false
        self.currentTrack = nil
    }

    func pause() {
        self.isPlaying = false
    }

    // 6. These fix the "next" and "previous" call errors
    func nextTrack() {
        guard !playlist.isEmpty else { return }
        currentIndex = (currentIndex + 1) % playlist.count
        let next = playlist[currentIndex]
        currentTrack = next
        isPlaying = true
        if let urlString = next.audioUrl, let url = URL(string: urlString) {
            PlaybackManager.shared.updateNowPlaying(title: next.title, artist: next.artist)
            PlaybackManager.shared.play(url: url)
        }
    }

    func previousTrack() {
        guard !playlist.isEmpty else { return }
        currentIndex = (currentIndex - 1 + playlist.count) % playlist.count
        let prev = playlist[currentIndex]
        currentTrack = prev
        isPlaying = true
        if let urlString = prev.audioUrl, let url = URL(string: urlString) {
            PlaybackManager.shared.updateNowPlaying(title: prev.title, artist: prev.artist)
            PlaybackManager.shared.play(url: url)
        }
    }

    func appendToPlaylist(_ tracks: [UnifiedTrack]) {
        guard !tracks.isEmpty else { return }
        self.playlist.append(contentsOf: tracks)
    }
}

