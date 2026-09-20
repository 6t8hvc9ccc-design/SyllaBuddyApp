//
//  notificationManager.swift
//  
//
//  Created by DMK on 20/09/2026.
//

import Foundation
import UserNotifications
 
class NotificationManager {
    static let shared = NotificationManager()
 
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                print("Notification auth error: \(error)")
            }
        }
    }
 
    func scheduleReminders(for event: DeadlineEvent) {
        schedule(
            id: "\(event.id)-week",
            title: "📅 Due in 1 week — \(event.title)",
            body: "\(event.type.rawValue), due \(formatted(event.date))",
            offsetDays: -7,
            eventDate: event.date
        )
        schedule(
            id: "\(event.id)-day",
            title: "⏰ Due tomorrow — \(event.title)",
            body: "\(event.type.rawValue) is due tomorrow (\(formatted(event.date)))",
            offsetDays: -1,
            eventDate: event.date
        )
    }
 
    func cancelReminders(for event: DeadlineEvent) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["\(event.id)-week", "\(event.id)-day"]
        )
    }
 
    private func schedule(id: String, title: String, body: String, offsetDays: Int, eventDate: Date) {
        guard let triggerDate = Calendar.current.date(byAdding: .day, value: offsetDays, to: eventDate),
              triggerDate > Date() else { return }
 
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
 
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
        comps.hour = 9
        comps.minute = 0
 
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
 
    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
 
