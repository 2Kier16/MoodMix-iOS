import Foundation
import AVFoundation

#if os(iOS)
class LocalMusicPlayer {

    
    private var player: AVPlayer?
    private var token: Any? // To store the notification observer
    
    func play(url: String, onTrackEnded: @escaping () -> Void) {
        stop()
        
        guard let localURL = URL(string: url) else {
            print("LocalPlayer: Invalid URL path")
            return
        }
        
        let playerItem = AVPlayerItem(url: localURL)
        player = AVPlayer(playerItem: playerItem)
        
        // Listen for when the track finishes
        token = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            onTrackEnded()
        }
        
        // Setup audio session for playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("LocalPlayer: Audio Session error - \(error.localizedDescription)")
        }
        
        player?.play()
    }
    
    func stop() {
        player?.pause()
        
        // Clean up the observer to prevent memory leaks or double-calls
        if let token = token {
            NotificationCenter.default.removeObserver(token)
            self.token = nil
        }
        
        player = nil
    }
    
    func release() {
        stop()
    }
}
#endif

