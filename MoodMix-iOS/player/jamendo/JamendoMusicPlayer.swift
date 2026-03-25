//
//  JamendoMusicPlayer.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation
import AVFoundation

class JamendoMusicPlayer {
    
    private var player: AVPlayer?
    
    func play(url: String) {
        // Clear any existing playback
        stop()
        
        guard let trackURL = URL(string: url) else {
            print("JamendoPlayer: Invalid URL - \(url)")
            return
        }
        
        // Create the player item and the player
        let playerItem = AVPlayerItem(url: trackURL)
        player = AVPlayer(playerItem: playerItem)
        
        // Configure Audio Session for background playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("JamendoPlayer: Audio Session error - \(error.localizedDescription)")
        }
        
        player?.play()
    }
    
    func stop() {
        player?.pause()
        player = nil // Releases the AVPlayer instance
    }
    
    func release() {
        stop()
    }
}