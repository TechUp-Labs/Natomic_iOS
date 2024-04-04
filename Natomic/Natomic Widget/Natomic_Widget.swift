//
//  Natomic_Widget.swift
//  Natomic Widget
//
//  Created by Archit Navadiya on 13/03/24.
//

import WidgetKit
import SwiftUI

let sharedUserDefaults = UserDefaults(suiteName: SharedUserDefaults.suiteName)
let slightlyLargerFontSize: CGFloat = 20 // Adjust as needed


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, userNotes: "Please write", noteDate: "", noteTime: "")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userNotes = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.userNote) as? String ?? "Not fetched"
        let entry = SimpleEntry(date: .now, userNotes: userNotes, noteDate: "", noteTime: "")
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date().zeroSeconds!
        for hourOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let userNotes = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.userNote) as? String ?? "It's time to write one line today!"
            let noteTime = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.noteTime) as? String ?? ""
            let noteDate = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.noteDate) as? String ?? ""
            
            let entry = SimpleEntry(date: entryDate, userNotes: userNotes, noteDate: formattedDate(from: noteDate), noteTime: noteTime)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-d"
        guard let date = inputFormatter.date(from: dateString) else {
            return "Add your note"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd, MMM, yyyy"
        return outputFormatter.string(from: date)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let userNotes: String
    let noteDate: String
    let noteTime: String
}

struct Natomic_WidgetEntryView: View {
    
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        
        ZStack { // Layer content on top of background
            Color(red: 0.949, green: 0.937, blue: 0.894)
                .ignoresSafeArea(.all)
                .padding(-18)
            
            VStack(alignment: .leading, spacing: 8) { // Content stack
                
                // Date View positioned at the top left
                HStack {
                    ZStack(alignment: .leading) { // Stack icon and text with spacing
                        Image(systemName: "calendar")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(entry.noteDate) // Assuming entry.noteDate is formatted appropriately
                            .font(getFontSizeBasedOnWidgetFamily())
                            .foregroundColor(.gray)
                            .minimumScaleFactor(0.7) // Adjust minimum scale factor for better scaling on smaller screens
                            .lineLimit(1) // Limit to one line to prevent text overflow
                            .truncationMode(.tail) // Add ellipsis for long text
                            .padding(.leading, 16) // Adjust for desired spacing (3-4 units)
                    }
                    Spacer() // This pushes the date to the left
                }
                .padding(.bottom, 5) // Optional: adjust space between the date and the note
                
                // User Note Text View
                Text(entry.userNotes)
                    .font(.system(size: slightlyLargerFontSize)) // Define `slightlyLargerFontSize` appropriately
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(minHeight: entry.userNotes.lineCount > 1 ? 70 : 70) // Make sure `lineCount` is computed correctly
                    .truncationMode(.tail)
                    .padding(.top, -15)
                
                HStack(alignment: .center) { // Center content vertically
                    Image("Natomic_logo")  // Replace with your image name
                        .resizable()  // Allow image to resize
                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                        .frame(width: 22, height: 22) // Adjust image size as needed
                    
                    Spacer()  // Push button to the right
                    
                    Button(action: {}) { // Disabled button
                        Text("Write")
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray) // Disabled color
                            .background(Color.clear)
                    }
                    .background( // Apply background with rounded corners
                        RoundedRectangle(cornerRadius: 12.5) // Adjust corner radius as needed
                            .fill(Color.gray.opacity(0.2)) // Set desired background color
                            .frame(width: 45, height: 25)
                    )
                    .buttonStyle(.plain)
                    .disabled(true) // Disable button interaction
                    .opacity(0.7) // Slightly transparent for visual indication
                }
                .padding(.top, 5) // Add horizontal padding

            }
            .padding(.horizontal, 10) // Add horizontal padding
            .padding(.vertical, 50) // Add vertical padding
        }
        .widgetURL(URL(string: "natomic://openSpecificView"))
    }
    
    func getFontSizeBasedOnWidgetFamily() -> Font {
      switch family {
      case .systemSmall:
        return .system(size: 16)
      case .systemMedium:
        return .system(size: 16)
      default:
        return .system(size: 16) // Default for other sizes
      }
    }
}


struct Natomic_Widget: Widget {
    static var sharedUserDefaults: UserDefaults? {
        // Ensure App Group is enabled in Capabilities and properly configured
        UserDefaults(suiteName: SharedUserDefaults.suiteName)
    }
    
    let kind: String = "Natomic_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
            if #available(iOS 17.0, *) {
                Natomic_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Natomic_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

extension Date {
    
    var zeroSeconds: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)
    }
}

extension String {
    var lineCount: Int {
        return components(separatedBy: .newlines).count
    }
}
