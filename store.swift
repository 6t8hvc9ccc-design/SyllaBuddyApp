//
//  store.swift
//  
//
//  Created by DMK on 20/09/2026.
//

import Foundation
 
@MainActor
class Store: ObservableObject {
    @Published var courses: [Course] = [] { didSet { save() } }
    @Published var events: [DeadlineEvent] = [] { didSet { save() } }
 
    private let coursesKey = "syllabuddy.courses"
    private let eventsKey = "syllabuddy.events"
 
    init() { load() }
 
    func load() {
        if let data = UserDefaults.standard.data(forKey: coursesKey),
           let decoded = try? JSONDecoder().decode([Course].self, from: data) {
            courses = decoded
        }
        if let data = UserDefaults.standard.data(forKey: eventsKey),
           let decoded = try? JSONDecoder().decode([DeadlineEvent].self, from: data) {
            events = decoded
        }
    }
 
    func save() {
        if let data = try? JSONEncoder().encode(courses) {
            UserDefaults.standard.set(data, forKey: coursesKey)
        }
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: eventsKey)
        }
    }
 
    func addCourse(name: String, colorHex: String, icon: String) {
        courses.append(Course(name: name, colorHex: colorHex, icon: icon))
    }
 
    func deleteCourse(_ course: Course) {
        events.filter { $0.courseID == course.id }.forEach { NotificationManager.shared.cancelReminders(for: $0) }
        courses.removeAll { $0.id == course.id }
        events.removeAll { $0.courseID == course.id }
    }
 
    func addEvent(courseID: UUID, title: String, type: EventType, date: Date) {
        var event = DeadlineEvent(courseID: courseID, title: title, type: type, date: date)
        NotificationManager.shared.scheduleReminders(for: event)
        event.remindersSet = true
        events.append(event)
    }
 
    func deleteEvent(_ event: DeadlineEvent) {
        NotificationManager.shared.cancelReminders(for: event)
        events.removeAll { $0.id == event.id }
    }
 
    func course(for id: UUID) -> Course? {
        courses.first { $0.id == id }
    }
 
    var nextColor: String {
        coursePalette[courses.count % coursePalette.count]
    }
}
