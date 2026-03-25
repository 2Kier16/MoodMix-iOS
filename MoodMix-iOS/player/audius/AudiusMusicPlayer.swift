//
//  AudiusMusicPlayer.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import Foundation
import AVFoundation

class AudiusMusicPlayer {
    
    private var player: AVPlayer?
    
    func play(url: String) {
        // Equivalent to stop() and release() in Kotlin
        stop()
        
        guard let streamURL = URL(string: url) else {
            print("AudiusPlayer: Invalid URL string")
            return
        }
        
        // AVPlayer handles the "Prepare" and "Play" steps
        let playerItem = AVPlayerItem(url: streamURL)
        player = AVPlayer(playerItem: playerItem)
        
        // Ensure the audio session is active for playback
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        player?.play()
    }
    
    func stop() {
        player?.pause()
        // In Swift, setting to nil allows ARC to release the memory
        player = nil 
    }
    
    func release() {
        stop()
    }
}