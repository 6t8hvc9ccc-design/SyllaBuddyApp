//
//  eventView.swift
//  
//
//  Created by DMK on 20/09/2026.
//

import SwiftUI
 
struct EventsView: View {
    @EnvironmentObject var store: Store
    @State private var showingAddEvent = false
 
    var sortedEvents: [DeadlineEvent] {
        store.events.sorted { $0.date < $1.date }
    }
 
    var body: some View {
        NavigationView {
            ScrollView {
                GradientHeader(
                    title: "Your Deadlines",
                    subtitle: "\(sortedEvents.count) upcoming across \(store.courses.count) course\(store.courses.count == 1 ? "" : "s")"
                )
 
                LazyVStack(spacing: 12) {
                    if store.courses.isEmpty {
                        EmptyStateView(
                            icon: "books.vertical",
                            title: "Add a course first",
                            message: "Head to the Courses tab to add your first course, then come back here to add deadlines."
                        )
                        .padding(.top, 20)
                    } else if sortedEvents.isEmpty {
                        EmptyStateView(
                            icon: "calendar.badge.plus",
                            title: "No deadlines yet",
                            message: "Tap the + button below to add an exam, quiz, or submission date."
                        )
                        .padding(.top, 20)
                    } else {
                        ForEach(sortedEvents) { event in
                            EventCard(event: event)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 90)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingAddEvent = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 58, height: 58)
                        .background(
                            LinearGradient(colors: Brand.gradient, startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                }
                .disabled(store.courses.isEmpty)
                .padding(24)
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView()
            }
        }
    }
}
 
struct EventCard: View {
    @EnvironmentObject var store: Store
    let event: DeadlineEvent
 
    var course: Course? { store.course(for: event.courseID) }
 
    var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: event.date).day ?? 0
    }
 
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: course?.colorHex ?? "999999").opacity(0.15))
                    .frame(width: 46, height: 46)
                Image(systemName: event.type.icon)
                    .foregroundStyle(Color(hex: course?.colorHex ?? "999999"))
                    .font(.system(size: 18, weight: .semibold))
            }
 
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(course?.name ?? "Unknown course")
                    Text("·")
                    Text(event.type.rawValue)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
 
            Spacer()
 
            VStack(alignment: .trailing, spacing: 6) {
                Text(event.date, format: .dateTime.day().month(.abbreviated))
                    .font(.subheadline.weight(.bold))
                DaysLeftBadge(daysLeft: daysLeft)
            }
        }
        .cardStyle()
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                store.deleteEvent(event)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
 
struct AddEventView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
 
    @State private var title = ""
    @State private var selectedCourseID: UUID?
    @State private var type: EventType = .exam
    @State private var date = Date()
 
    var body: some View {
        NavigationView {
            Form {
                Section("Course") {
                    Picker("Course", selection: $selectedCourseID) {
                        ForEach(store.courses) { course in
                            Label(course.name, systemImage: course.icon)
                                .tag(Optional(course.id))
                        }
                    }
                }
                Section("Details") {
                    TextField("Title (e.g. Sprint 3 Submission)", text: $title)
                    Picker("Type", selection: $type) {
                        ForEach(EventType.allCases) { t in
                            Label(t.rawValue, systemImage: t.icon).tag(t)
                        }
                    }
                    DatePicker("Due date", selection: $date, displayedComponents: .date)
                }
                Section {
                    Label("Reminders are scheduled automatically for 7 days before and 1 day before this date.", systemImage: "bell.badge.fill")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Add Deadline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let courseID = selectedCourseID, !title.isEmpty else { return }
                        store.addEvent(courseID: courseID, title: title, type: type, date: date)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(selectedCourseID == nil || title.isEmpty)
                }
            }
            .onAppear {
                if selectedCourseID == nil {
                    selectedCourseID = store.courses.first?.id
                }
            }
        }
    }
}
