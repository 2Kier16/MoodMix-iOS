//
//  MainScaffold.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import SwiftUI

struct MainScaffold: View {
    // Observing the 'Brain' ViewModel for mood and loading states
    @ObservedObject var brainViewModel: MoodBrainViewModel
    
    // Navigation callback equivalent to onGoToJournal: () -> Unit
    var onGoToJournal: () -> Void

    var body: some View {
        ScrollView { // Equivalent to verticalScroll(scrollState)
            VStack(alignment: .center, spacing: 16) {
                
                Spacer().frame(height: 24)

                // Header
                Text("Welcome to MoodMix")
                    .font(.title) // headlineMedium equivalent
                    .fontWeight(.bold)
                
                Text("Select a mood below and press \"Start\" to begin your personalized music journey.")
                    .font(.body) // bodyLarge equivalent
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)

                // Mood Selection Component
                MoodSelector(
                    selectedMood: brainViewModel.selectedMood,
                    onMoodSelected: { mood in
                        brainViewModel.setMood(mood)
                    }
                )

                Spacer().frame(height: 24)

                // Action: Start Music
                Button(action: {
                    // Task handles the async 'loadTracksForMood' call
                    Task {
                        await brainViewModel.loadTracksForMood(mood: brainViewModel.selectedMood)
                    }
                }) {
                    Text("Start MoodMix")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Loading Indicator
                if brainViewModel.isLoading {
                    ProgressView() // CircularProgressIndicator equivalent
                        .padding(.top, 16)
                }

                Spacer().frame(height: 16)

                // Action: Go to Reflection Space
                Button(action: onGoToJournal) {
                    Text("Reflection Space")
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accentColor, lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 32)
            }
            .padding(16)
        }
        .background(Color(UIColor.systemBackground))
    }
}