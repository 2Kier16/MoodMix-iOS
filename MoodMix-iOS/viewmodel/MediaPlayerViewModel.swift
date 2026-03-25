//
//  MediaPlayerViewModel.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//

import Foundation
import Combine
import AVFoundation
import MediaPlayer // <-- Required for Apple Music playback!

class MediaPlayerViewModel: ObservableObject {
    static let shared = MediaPlayerViewModel()
    
    @Published var currentTrack: UnifiedTrack?
    @Published var isPlaying: Bool = false
    @Published var currentIndex: Int = 0
    
    var playlistCount: Int { playlist.count }
    
    private var playlist: [UnifiedTrack] = []
    
    // Player for internet streams (Audius/Jamendo)
    private var avPlayer: AVPlayer?
    
    // Apple's official player for local Apple Music
    private let applePlayer = MPMusicPlayerController.applicationQueuePlayer
    
    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func setPlaylist(_ tracks: [UnifiedTrack]) {
        playlist = tracks
        currentIndex = 0
        playTrack(at: currentIndex)
    }
    
    func appendToPlaylist(_ tracks: [UnifiedTrack]) {
        playlist.append(contentsOf: tracks)
    }
    
    func play() {
        if let track = currentTrack {
            if track.source == .LOCAL {
                applePlayer.play()
            } else {
                avPlayer?.play()
            }
            isPlaying = true
        }
    }
    
    func pause() {
        if let track = currentTrack {
            if track.source == .LOCAL {
                applePlayer.pause()
            } else {
                avPlayer?.pause()
            }
            isPlaying = false
        }
    }
    
    func stop() {
        avPlayer?.pause()
        applePlayer.stop()
        isPlaying = false
    }
    
    func nextTrack() {
        guard currentIndex < playlist.count - 1 else { stop(); return }
        currentIndex += 1
        playTrack(at: currentIndex)
    }
    
    func previousTrack() {
        guard currentIndex > 0 else { stop(); return }
        currentIndex -= 1
        playTrack(at: currentIndex)
    }
    
    private func playTrack(at index: Int) {
        guard index >= 0 && index < playlist.count else { return }
        let track = playlist[index]
        currentTrack = track
        
        stop()
        
        if track.source == .LOCAL {
            // Play using Apple Music Player
            if let pid = UInt64(track.id) {
                let query = MPMediaQuery.songs()
                let predicate = MPMediaPropertyPredicate(value: pid, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
                query.addFilterPredicate(predicate)
                
                if let item = query.items?.first {
                    let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: [item]))
                    applePlayer.setQueue(with: descriptor)
                    applePlayer.prepareToPlay()
                    applePlayer.play()
                    isPlaying = true
                }
            }
        } else {
            // Play streaming internet URL via AVPlayer
            guard let urlString = track.audioUrl, let url = URL(string: urlString) else { return }
            avPlayer = AVPlayer(url: url)
            avPlayer?.play()
            isPlaying = true
        }
    }
}

