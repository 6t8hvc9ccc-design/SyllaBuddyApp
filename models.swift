//
//  models.swift
//  
//
//  Created by DMK on 20/09/2026.
//

import SwiftUI
 
enum EventType: String, Codable, CaseIterable, Identifiable {
    case exam = "Exam"
    case quiz = "Quiz"
    case submission = "Submission"
    case project = "Project"
 
    var id: String { rawValue }
 
    var icon: String {
        switch self {
        case .exam: return "pencil.and.outline"
        case .quiz: return "questionmark.circle.fill"
        case .submission: return "tray.and.arrow.up.fill"
        case .project: return "folder.fill"
        }
    }
}
 
struct Course: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var colorHex: String     // e.g. "2563EB"
    var icon: String = "book.closed.fill"
}
 
struct DeadlineEvent: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var courseID: UUID
    var title: String
    var type: EventType
    var date: Date
    var remindersSet: Bool = false
}
 
// MARK: - Palette
 
/// A curated, good-looking palette so every course gets a distinct, pleasant color automatically.
let coursePalette: [String] = [
    "2563EB", // blue
    "059669", // green
    "D97706", // amber
    "DC2626", // red
    "7C3AED", // violet
    "DB2777", // pink
    "0891B2", // cyan
    "65A30D", // lime
]
 
let courseIconChoices: [String] = [
    "book.closed.fill", "laptopcomputer", "function", "atom",
    "paintbrush.fill", "chart.bar.fill", "globe", "cpu.fill"
]
 
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
