//
//  Natomic_Widget.swift
//  Natomic Widget
//
//  Created by Archit Navadiya on 13/03/24.
//

import WidgetKit
import SwiftUI

let sharedUserDefaults = UserDefaults(suiteName: SharedUserDefaults.suiteName)
let slightlyLargerFontSize: CGFloat = 18 // Adjust as needed


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: .now, userNotes: "Please write", noteDate: "", noteTime: "", streak: "0", weekData: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userNotes = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.userNote) as? String ?? "Not fetched"
        let weekData = retrieveWeekDataFromUserDefaults() ?? []
        let entry = SimpleEntry(date: .now, userNotes: userNotes, noteDate: "", noteTime: "", streak: "0", weekData: weekData)
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date().zeroSeconds!
        let weekData = retrieveWeekDataFromUserDefaults() ?? []
        
        for hourOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let userNotes = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.userNote) ?? "It's time to write one line today!"
            let noteTime = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.noteTime) ?? ""
            let noteDate = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.noteDate) ?? ""
            let streak = sharedUserDefaults?.string(forKey: SharedUserDefaults.Keys.streak) ?? ""

            let entry = SimpleEntry(date: entryDate, userNotes: userNotes, noteDate: formattedDate(from: noteDate), noteTime: noteTime, streak: streak, weekData: weekData)
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
    
    func retrieveWeekDataFromUserDefaults() -> [WeekDayData]? {
        if let savedWeekData = sharedUserDefaults?.data(forKey: SharedUserDefaults.Keys.weekData) {
            let decoder = JSONDecoder()
            if let loadedWeekData = try? decoder.decode([WeekDayData].self, from: savedWeekData) {
                return loadedWeekData
            } else {
                print("Failed to decode week data")
            }
        }
        return nil
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let userNotes: String
    let noteDate: String
    let noteTime: String
    let streak: String
    let weekData: [WeekDayData]
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
                .padding(.bottom, 10)

                
                // User Note Text View
                Text(entry.userNotes)
                    .font(.system(size: slightlyLargerFontSize)) // Define `slightlyLargerFontSize` appropriately
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(minHeight: entry.userNotes.lineCount > 1 ? 70 : 70) // Make sure `lineCount` is computed correctly
                    .truncationMode(.tail)
                    .padding(.top, -15)
                
                
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

struct StreakSmallViewEntryView : View {
    
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        ZStack{
            Color(red: 0.949, green: 0.937, blue: 0.894)
                .ignoresSafeArea(.all)
                .padding(-18)
            
            VStack{
                Image("streackLargeIcon")
                    .resizable()  // Allow image to resize
                    .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                    .frame(width: 80, height: 80) // Adjust image size as needed
//                Divider()
                if #available(iOSApplicationExtension 16.0, *) {
                    Text("\(entry.streak) day streak!")
                        .multilineTextAlignment(.center) // Center align the text
                        .font(.system(size: 16))
                        .bold()
                        .lineLimit(2) // Allow two lines of text
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("10 day streak!")
                        .multilineTextAlignment(.center) // Center align the text
                        .font(.system(size: 16))
                        .lineLimit(2) // Allow two lines of text
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Rectangle()
                    .frame(height: 1) // Set the height of the line
                    .frame(maxWidth: .infinity) // Make the line full width
                    .foregroundColor(.gray) // Set the color of the line
                Text("Time to write")
                    .foregroundColor(Color(red: 0.474, green:0.447, blue: 0.375))
                    .multilineTextAlignment(.center) // Center align the text
                    .font(.system(size: 14))
                    .lineLimit(2) // Allow two lines of text
            }
        }
        .widgetURL(URL(string: "natomic://openSpecificView"))

    }
}

struct Streak_MediumViewEntryView : View {
    
    var entry: Provider.Entry
    let width = (UIScreen.main.bounds.width/8)-12

    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        ZStack{
            Color(red: 0.949, green: 0.937, blue: 0.894)
                .ignoresSafeArea(.all)
                .padding(-18)
            
            VStack{
                HStack{
                    Text("Sun").foregroundColor(.black).font(.subheadline).frame(width: width, height: 30).font(.system(size: 14))
                    Text("Mon").foregroundColor(.black).font(.subheadline).frame(width: width, height: 30).font(.system(size: 14))
                    Text("Tue").foregroundColor(.black).font(.subheadline).frame(width: width, height: 30).font(.system(size: 14))
                    Text("Wed").foregroundColor(.black).font(.subheadline).frame(width: width, height: 30).font(.system(size: 14))
                    Text("Thu").foregroundColor(.black).font(.subheadline).frame(width: width, height: 30).font(.system(size: 14))
                    Text("Fri").foregroundColor(.black).font(.subheadline).frame(width: width, height: 30).font(.system(size: 14))
                    Text("Sat").foregroundColor(.black).font(.subheadline).frame(width: width, height: 30).font(.system(size: 14))
                }
                
                HStack {
                    ForEach(entry.weekData) { day in
                        Group {
                            if day.hasNote {
                                Image("streackSmallIcon")
                                    .frame(width: width, height: 30)
                            } else {
                                Image("streakFillIcon")
                                    .frame(width: width, height: 30)
                            }
                        }
                    }
                }
                
                Rectangle()
                    .frame(height: 1) // Set the height of the line
                    .frame(maxWidth: .infinity) // Make the line full width
                    .foregroundColor(Color(red: 0.474, green:0.447, blue: 0.375)) // Set the color of the line

                Text("Your streak will reset to zero if you miss tomorrow's write-up")
                    .multilineTextAlignment(.center) // Center align the text
                    .font(.system(size: 14))
                    .lineLimit(2) // Allow two lines of text
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
        }
        .widgetURL(URL(string: "natomic://openSpecificView"))

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
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Natomic")
        .description("This is an natomic widget.")
    }
}

struct Streak_SmallView: Widget {
    static var sharedUserDefaults: UserDefaults? {
        // Ensure App Group is enabled in Capabilities and properly configured
        UserDefaults(suiteName: SharedUserDefaults.suiteName)
    }
    
    let kind: String = "Streak_SmallView"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StreakSmallViewEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Test")
        .description("This is an natomic widget.")
    }
}

struct Streak_MediumView: Widget {
    static var sharedUserDefaults: UserDefaults? {
        // Ensure App Group is enabled in Capabilities and properly configured
        UserDefaults(suiteName: SharedUserDefaults.suiteName)
    }
    
    let kind: String = "Streak_SmallView"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Streak_MediumViewEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Streak_MediumView")
        .description("Streak MediumView.")
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

struct WeekDayData: Codable, Identifiable {
    let id = UUID()
    let date: String
    let dayName: String
    let hasNote: Bool
}
