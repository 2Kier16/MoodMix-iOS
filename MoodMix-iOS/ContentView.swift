//
//  ContentView.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/24/26.
//

import SwiftUI

enum AppScreen {
    case home
    case reflection
}

struct ContentView: View {
    // This automatically saves whether the user has finished onboarding
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    // Controls whether we are on the Home screen or the Journal/Reflection screen
    @State private var currentScreen: AppScreen = .home
    
    // Create the ViewModels that will power the app
    @StateObject private var brainViewModel = MoodBrainViewModel()
    
    // Pass the required dependencies to JournalViewModel
    @StateObject private var journalViewModel = JournalViewModel(
        repository: JournalRepository(),
        draftStore: JournalDraftDataStore()
    )
    
    var body: some View {
        // Wrap everything in your custom theme
        MoodMixTheme {
            // Group lets us apply the fullscreen frame to BOTH the onboarding and the main app
            Group {
                // 1. If we haven't seen onboarding, show ONLY the onboarding view
                if !hasSeenOnboarding {
                    OnboardingView(onDismiss: {
                        hasSeenOnboarding = true
                    })
                } else {
                    // 2. Otherwise, show the main app with the bottom-aligned ZStack
                    ZStack(alignment: .bottom) {
                        
                        // App Navigation State
                        if currentScreen == .home {
                            MainScaffold(
                                brainViewModel: brainViewModel,
                                onGoToJournal: {
                                    currentScreen = .reflection
                                }
                            )
                        } else if currentScreen == .reflection {
                            ReflectionView(
                                journalViewModel: journalViewModel,
                                onNavigateBack: {
                                    currentScreen = .home
                                },
                                onChangeMood: {
                                    currentScreen = .home
                                }
                            )
                        }
                        
                        // The Floating MiniPlayer
                        MiniPlayer(
                            brainViewModel: brainViewModel,
                            onExpand: {
                                // In the future, you can open a Full Player View here!
                            }
                        )
                    }
                }
            }
            // Ensures the content stretches to the edges of the screen
            // so the ScrollView actually has room to scroll!
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
