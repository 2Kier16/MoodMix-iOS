//
//  NowPlayingBar.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import SwiftUI

struct NowPlayingBar: View {
    let nowPlaying: NowPlayingState

    var body: some View {
        // Equivalent to if (!nowPlaying.isPlaying) return
        if nowPlaying.isPlaying {
            VStack(alignment: .leading, spacing: 4) {
                Text("Now Playing:")
                    .font(.caption) // titleSmall equivalent
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                Text(nowPlaying.title ?? "Unknown Title")
                    .font(.body) // bodyLarge equivalent
                    .fontWeight(.medium)
                    .lineLimit(1)

                Text(nowPlaying.artist ?? "Unknown Artist")
                    .font(.subheadline) // bodyMedium equivalent
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal, 16)
        } else {
            EmptyView()
        }
    }
}