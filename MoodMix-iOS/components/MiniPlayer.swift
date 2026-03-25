//
//  MiniPlayer.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import SwiftUI

struct MiniPlayer: View {
    @ObservedObject var brainViewModel: MoodBrainViewModel
    var onExpand: () -> Void

    var body: some View {
        // Equivalent to: if (!nowPlaying.isPlaying && nowPlaying.title.isBlank()) return
        if !brainViewModel.nowPlaying.isPlaying && (brainViewModel.nowPlaying.title ?? "").isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                Divider() // Subtle separator
                
                HStack(spacing: 12) {
                    // Track Info Column
                    VStack(alignment: .leading, spacing: 2) {
                        Text(brainViewModel.nowPlaying.title ?? "Unknown Title")
                            .font(.body) // bodyLarge
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        Text(brainViewModel.nowPlaying.artist ?? "Unknown Artist")
                            .font(.footnote) // bodyMedium
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Player Controls Row
                    HStack(spacing: 0) {
                        // Previous Button
                        Button(action: { brainViewModel.previousTrack() }) {
                            Image(systemName: "backward.fill") // Icons.Default.SkipPrevious
                                .padding(8)
                        }
                        
                        // Play/Pause Button
                        Button(action: {
                            if brainViewModel.nowPlaying.isPlaying {
                                brainViewModel.pause()
                            } else {
                                brainViewModel.resume()
                            }
                        }) {
                            Image(systemName: brainViewModel.nowPlaying.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .padding(8)
                        }
                        
                        // Stop Button
                        Button(action: { brainViewModel.stopPlayback() }) {
                            Image(systemName: "stop.fill") // Icons.Default.Stop
                                .padding(8)
                        }
                        
                        // Next Button
                        Button(action: { brainViewModel.nextTrack() }) {
                            Image(systemName: "forward.fill") // Icons.Default.SkipNext
                                .padding(8)
                        }
                    }
                    .foregroundColor(.primary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(UIColor.secondarySystemBackground)) // tonalElevation
                .onTapGesture {
                    onExpand() // clickable { onExpand() }
                }
            }
            .transition(.move(edge: .bottom)) // Animates appearance
        }
    }
}
