//
//  MoodBrainViewModel.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//
import Foundation
import Combine
import SwiftUI

class MoodBrainViewModel: ObservableObject {
    
    // Repositories
    private let trackRepository = UnifiedTrackRepository()
    private var mediaPlayer: MediaPlayerViewModel = MediaPlayerViewModel.shared
    
    // Published States
    @Published var nowPlaying = NowPlayingState()
    @Published var tracks: [UnifiedTrack] = []
    @Published var selectedMood: String = "Calm"
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var isPrefetching = false

    init() {
        setupObservers()
    }

    private func setupObservers() {
        mediaPlayer.$currentTrack
            .receive(on: RunLoop.main)
            .sink { [weak self] track in
                guard let self = self else { return }
                if let track = track {
                    self.nowPlaying = NowPlayingState(
                        isPlaying: self.mediaPlayer.isPlaying,
                        title: track.title,
                        artist: track.artist
                    )
                } else {
                    self.nowPlaying = .empty
                }
            }
            .store(in: &cancellables)
        
        mediaPlayer.$isPlaying
            .receive(on: RunLoop.main)
            .sink { [weak self] playing in
                self?.nowPlaying.isPlaying = playing
            }
            .store(in: &cancellables)
        
        mediaPlayer.$currentIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] idx in
                guard let self = self else { return }
                let remaining = self.mediaPlayer.playlistCount - idx - 1
                if remaining <= 2, !self.isPrefetching {
                    self.isPrefetching = true
                    Task { [weak self] in
                        guard let self = self else { return }
                        let more = await self.trackRepository.getTracksForMood(mood: self.selectedMood)
                        await MainActor.run {
                            self.mediaPlayer.appendToPlaylist(more)
                            self.isPrefetching = false
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }

    func setMood(_ mood: String) {
        self.selectedMood = mood
    }

    @MainActor
    func loadTracksForMood(mood: String) async {
        self.isLoading = true
        self.mediaPlayer.stop()
        self.tracks = []

        let fetchedTracks = await trackRepository.getTracksForMood(mood: mood)
        self.tracks = fetchedTracks
        
        if !fetchedTracks.isEmpty {
            mediaPlayer.setPlaylist(fetchedTracks)
            mediaPlayer.play()
        }

        self.isLoading = false
    }

    // Control Methods
    func pause() { mediaPlayer.pause() }
    func resume() { mediaPlayer.play() }
    func stopPlayback() {
        mediaPlayer.stop()
        nowPlaying = .empty
    }
    func nextTrack() { mediaPlayer.nextTrack() }
    func previousTrack() { mediaPlayer.previousTrack() }
}

