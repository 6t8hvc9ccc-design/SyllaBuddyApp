//
//  coursesView.swift
//  
//
//  Created by DMK on 20/09/2026.
//


import SwiftUI
 
struct CoursesView: View {
    @EnvironmentObject var store: Store
    @State private var showingAddCourse = false
 
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
 
    var body: some View {
        NavigationView {
            ScrollView {
                GradientHeader(
                    title: "Your Courses",
                    subtitle: "\(store.courses.count) course\(store.courses.count == 1 ? "" : "s") tracked",
                    colors: [Color(hex: "059669"), Color(hex: "0891B2")]
                )
 
                if store.courses.isEmpty {
                    EmptyStateView(
                        icon: "books.vertical",
                        title: "No courses yet",
                        message: "Tap + to add your first course, then start adding its deadlines."
                    )
                    .padding(.top, 20)
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(store.courses) { course in
                            CourseCard(course: course)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
 
                Spacer(minLength: 90)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingAddCourse = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 58, height: 58)
                        .background(
                            LinearGradient(colors: [Color(hex: "059669"), Color(hex: "0891B2")], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                }
                .padding(24)
            }
            .sheet(isPresented: $showingAddCourse) {
                AddCourseView()
            }
        }
    }
}
 
struct CourseCard: View {
    @EnvironmentObject var store: Store
    let course: Course
 
    var eventCount: Int {
        store.events.filter { $0.courseID == course.id }.count
    }
 
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color(hex: course.colorHex).opacity(0.18))
                    .frame(width: 42, height: 42)
                Image(systemName: course.icon)
                    .foregroundStyle(Color(hex: course.colorHex))
                    .font(.system(size: 18, weight: .semibold))
            }
            Text(course.name)
                .font(.subheadline.weight(.bold))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text("\(eventCount) deadline\(eventCount == 1 ? "" : "s")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
        .contextMenu {
            Button(role: .destructive) {
                store.deleteCourse(course)
            } label: {
                Label("Delete Course", systemImage: "trash")
            }
        }
    }
}
 
struct AddCourseView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
 
    @State private var name = ""
    @State private var selectedColor: String = coursePalette[0]
    @State private var selectedIcon: String = courseIconChoices[0]
 
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: selectedColor).opacity(0.18))
                                    .frame(width: 64, height: 64)
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundStyle(Color(hex: selectedColor))
                            }
                            Text(name.isEmpty ? "Course name" : name)
                                .font(.headline)
                                .foregroundStyle(name.isEmpty ? .secondary : .primary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
 
                Section("Name") {
                    TextField("e.g. IT8108 — Mobile Programming", text: $name)
                }
 
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 10) {
                        ForEach(coursePalette, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle().stroke(Color.primary, lineWidth: selectedColor == hex ? 2 : 0)
                                        .padding(-3)
                                )
                                .onTapGesture { selectedColor = hex }
                        }
                    }
                    .padding(.vertical, 6)
                }
 
                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 10) {
                        ForEach(courseIconChoices, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.system(size: 17))
                                .frame(width: 32, height: 32)
                                .background(selectedIcon == icon ? Color(hex: selectedColor).opacity(0.2) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture { selectedIcon = icon }
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("New Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !name.isEmpty else { return }
                        store.addCourse(name: name, colorHex: selectedColor, icon: selectedIcon)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                selectedColor = store.nextColor
            }
        }
    }
}
