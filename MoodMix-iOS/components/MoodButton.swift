//
//  MoodButton.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import SwiftUI

struct MoodButton: View {
    let label: String
    let icon: String // We added this to support Apple's native icons!
    let color: Color
    var isSelected: Bool = false
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack(spacing: 8) {
                // This displays the Apple SF Symbol icon
                Image(systemName: icon)
                    .font(.title)
                
                Text(label)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .padding(4)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(color)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(isSelected ? 0.5 : 0), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
