//
//  MoodSelector.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//

import SwiftUI

struct MoodSelector: View {
    let selectedMood: String
    var onMoodSelected: (String) -> Void

    // Using clean strings and Apple's SF Symbols!
    private let moods: [(label: String, icon: String, color: Color)] = [
        ("Sad", "cloud.rain.fill", Color(red: 0x4A/255, green: 0x90/255, blue: 0xE2/255)),
        ("Happy", "sun.max.fill", Color(red: 0xBA/255, green: 0x55/255, blue: 0xD3/255)),
        ("Calm", "leaf.fill", Color(red: 0xF5/255, green: 0xF5/255, blue: 0xDC/255)),
        ("Angry", "flame.fill", Color(red: 0xD0/255, green: 0x02/255, blue: 0x1B/255)),
        ("Energetic", "bolt.fill", Color(red: 0x39/255, green: 0xFF/255, blue: 0x14/255)),
        ("Anxious", "wind", Color(red: 0xFF/255, green: 0x69/255, blue: 0xB4/255))
    ]

    // This creates 3 perfectly equal columns!
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        // LazyVGrid automatically makes all items the exact same width
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(moods, id: \.label) { item in
                MoodButton(
                    label: item.label,
                    icon: item.icon,
                    color: item.color,
                    isSelected: selectedMood == item.label,
                    onClick: { onMoodSelected(item.label) }
                )
            }
        }
        .padding()
    }
}

