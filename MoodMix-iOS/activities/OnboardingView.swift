//
//  OnboardingView 2.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import SwiftUI

struct OnboardingView: View {
    // Callback to dismiss the onboarding, equivalent to onDismiss: () -> Unit
    var onDismiss: () -> Void
    
    var body: some View {
        ScrollView { // Equivalent to .verticalScroll(rememberScrollState())
            VStack(alignment: .center, spacing: 24) {
                
                Spacer().frame(height: 24)
                
                // Welcome Header
                Text("Welcome to MoodMix")
                    .font(.largeTitle) // Equivalent to displaySmall
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor) // Equivalent to primary color
                    .multilineTextAlignment(.center)

                // A Safe Space Section
                VStack(spacing: 8) {
                    Text("A Safe Space to Heal")
                        .font(.title2) // Equivalent to headlineSmall
                        .fontWeight(.semibold)
                    
                    Text("MoodMix was born from a belief that music and journaling can be powerful tools for emotional clarity. This app is more than a project—it's a private corner for you to process emotions, find new music you've never heard before, and heal.")
                        .font(.body) // Equivalent to bodyLarge
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }

                // Discovering Music Section
                VStack(spacing: 8) {
                    Text("Discovering the Music")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("We focus on free, independent artists from around the world (via Jamendo and Audius). While you can't select specific tracks yet, you have full control to skip or rewind until you find the song that resonates with you. The artist and title will always be displayed as you listen.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }

                // Reflection Section
                VStack(spacing: 8) {
                    Text("Reflection & Release")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("In the Reflection Space, you can capture your journey. Use 'Save' to keep a permanent journal of your thoughts. Or use **'Release'**—a special feature to vent your frustrations and simply let them go. Once you hit Release, the burden is gone, and the space is clear.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }

                // The Future Section
                VStack(spacing: 8) {
                    Text("The Future")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("MoodMix is expanding! Soon, we'll introduce iOS, Tablet, and Desktop versions. We're also working on custom moods and future connections to services like Amazon Music, Spotify (Premium), YouTube Music, Pandora, and SoundCloud.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }

                Spacer().frame(height: 24)

                // Dismiss Button
                Button(action: onDismiss) {
                    Text("Begin My Journey")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Spacer().frame(height: 24)
            }
            .padding(24)
        }
        .background(Color(UIColor.systemBackground)) // Equivalent to MaterialTheme.colorScheme.background
    }
}