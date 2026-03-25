//
//  MoodMixView.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/26/26.
//


import SwiftUI

struct MoodMixView: View {
    // In SwiftUI, we observe the ViewModel
    @ObservedObject var viewModel: MoodMixViewModel
    
    // Callback closure equivalent to (String) -> Unit
    var onStartMoodMix: (String) -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Equivalent to Text with headlineSmall style
            Text("Selected Mood: \(viewModel.selectedMood)")
                .font(.title3)
                .fontWeight(.medium)

            // Custom component (we'll need to write this next)
            MoodSelector(
                selectedMood: viewModel.selectedMood,
                onMoodSelected: { mood in
                    viewModel.setMood(mood)
                }
            )

            // Equivalent to Button
            Button(action: {
                onStartMoodMix(viewModel.selectedMood)
            }) {
                Text("Start MoodMix")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Conditional UI logic
            if viewModel.isLoading {
                ProgressView() // Equivalent to CircularProgressIndicator
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
            } else if !viewModel.tracks.isEmpty {
                Text("Found \(viewModel.tracks.count) tracks")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}