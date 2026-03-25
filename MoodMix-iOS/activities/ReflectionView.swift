//
//  ReflectionView.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import SwiftUI

struct ReflectionView: View {
    @ObservedObject var journalViewModel: JournalViewModel
    var onNavigateBack: () -> Void
    var onChangeMood: () -> Void
    
    // Local state for the text editor to keep typing smooth
    @State private var notes: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header Row
            HStack {
                Text("Reflection Space")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: onChangeMood) {
                    Image(systemName: "house.fill")
                        .font(.title2)
                }
            }
            
            // Current Context Display
            if !journalViewModel.draftState.trackTitle.isEmpty {
                let artistInfo = !journalViewModel.draftState.trackArtist.isEmpty ? " by \(journalViewModel.draftState.trackArtist)" : ""
                Text("Listened to: \(journalViewModel.draftState.trackTitle)\(artistInfo)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if !journalViewModel.draftState.mood.isEmpty {
                Text("Mood: \(journalViewModel.draftState.mood)")
                    .font(.headline)
            }
            
            // Draft Editor
            TextEditor(text: $notes)
                .frame(height: 150)
                .padding(4)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .onChange(of: notes) { newValue in
                    journalViewModel.saveDraftNotes(newValue)
                }
            
            // Action Buttons
            HStack(spacing: 8) {
                // SAVE / UPDATE BUTTON
                Button(action: { journalViewModel.saveEntry() }) {
                    Text(journalViewModel.draftState.id == nil ? "Save" : "Update")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // RELEASE / CANCEL BUTTON
                Button(action: {
                    notes = ""
                    journalViewModel.clearDraft()
                }) {
                    Text(journalViewModel.draftState.id == nil ? "Release" : "Cancel")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
            }
            
            Divider().padding(.vertical, 8)
            
            Text("Past Reflections")
                .font(.title3)
                .fontWeight(.semibold)
            
            // History List
            List {
                ForEach(journalViewModel.entries) { entry in
                    ReflectionCard(entry: entry) {
                        journalViewModel.loadEntryForEditing(entry)
                    } onDelete: {
                        journalViewModel.deleteEntry(entry)
                    }
                    .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .onAppear {
            notes = journalViewModel.draftState.notes
        }
        .onChange(of: journalViewModel.draftState.notes) { newValue in
            if notes != newValue {
                notes = newValue
            }
        }
    }
}

struct ReflectionCard: View {
    let entry: ReflectionEntry
    var onTap: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    if let track = entry.trackTitle, !track.isEmpty {
                        let artistLine = (entry.trackArtist?.isEmpty == false) ? " by \(entry.trackArtist!)" : ""
                        Text("Listened to: \(track)\(artistLine)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Mood: \(entry.mood)")
                        .font(.headline)
                    
                    Text(entry.notes)
                        .font(.body)
                        .lineLimit(3)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            
            Text(formatDate(entry.timestamp))
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .onTapGesture(perform: onTap)
    }
    
    func formatDate(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}

