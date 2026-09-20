//
//  DesignSystem.swift
//  
//
//  Created by DMK on 20/09/2026.
//

import SwiftUI
 
enum Brand {
    static let gradient = [Color(hex: "2563EB"), Color(hex: "7C3AED")]
    static let cardCorner: CGFloat = 18
}
 
extension View {
    func cardStyle() -> some View {
        self
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: Brand.cardCorner, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}
 
/// A colorful gradient header used at the top of each tab.
struct GradientHeader: View {
    let title: String
    let subtitle: String
    var colors: [Color] = Brand.gradient
 
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal)
        .padding(.top, 4)
    }
}
 
/// Small rounded pill showing how urgent a deadline is, color-coded.
struct DaysLeftBadge: View {
    let daysLeft: Int
 
    var color: Color {
        if daysLeft < 0 { return .gray }
        if daysLeft <= 1 { return .red }
        if daysLeft <= 7 { return .orange }
        return .green
    }
 
    var label: String {
        if daysLeft < 0 { return "Past" }
        if daysLeft == 0 { return "Today" }
        if daysLeft == 1 { return "Tomorrow" }
        return "\(daysLeft)d left"
    }
 
    var body: some View {
        Text(label)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
 
/// A friendly empty-state view with icon + message.
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
 
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}
