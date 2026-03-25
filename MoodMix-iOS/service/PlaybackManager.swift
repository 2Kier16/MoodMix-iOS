import Foundation
import AVFoundation
import MediaPlayer

class PlaybackManager {
    // Singleton instance to be accessed by the ViewModels
    static let shared = PlaybackManager()
    
    private var player: AVQueuePlayer?
    
    private init() {
        setupAudioSession()
        setupRemoteCommandCenter()
        setupNotifications()
    }
    
    // MARK: - Setup
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            // .playback allows audio to continue in background/silent mode
            try session.setCategory(.playback, mode: .default, policy: .longFormAudio)
            try session.setActive(true)
        } catch {
            print("PlaybackManager: Failed to set up audio session: \(error)")
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Lock Screen Play
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.player?.play()
            return .success
        }
        
        // Lock Screen Pause
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause()
            return .success
        }
        
        // Lock Screen Next
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.player?.advanceToNextItem()
            return .success
        }
    }
    
    private func setupNotifications() {
        let nc = NotificationCenter.default
        
        // 1. Handle Phone Calls / Alarms (Interruptions)
        nc.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
            
            if type == .began {
                self?.player?.pause()
            } else if type == .ended {
                if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt,
                   AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume) {
                    self?.player?.play()
                }
            }
        }
        
        // 2. Handle Unplugging Headphones (Route Change / "Becoming Noisy")
        nc.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else { return }
            
            // If the old device was headphones and they were removed, pause playback
            if reason == .oldDeviceUnavailable {
                self?.player?.pause()
            }
        }
    }
    
    // MARK: - Public API
    
    /// Updates the Lock Screen / Control Center metadata
    func updateNowPlaying(title: String, artist: String) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func play(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        
        if player == nil {
            player = AVQueuePlayer(playerItem: playerItem)
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        player?.play()
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
            MediaPlayerViewModel.shared.nextTrack()
        }
    }
    
    func stop() {
        player?.pause()
        player?.removeAllItems()
    }
}
