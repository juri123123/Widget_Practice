//
//  MyWidget.swift
//  MyWidget
//
//  Created by 최주리 on 7/26/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), texts: ["Empty"])
    }
    
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), texts: ["Empty"])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        do {
            let texts = try await getTexts()
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, texts: texts)
            let nextRefresh = Calendar.current.date(byAdding: .second, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))

            return timeline
        } catch {
            print("error!!!!!\(error)")
        }
        
        return Timeline(entries: [], policy: .atEnd)
    }
    
    func getTexts() async throws -> [String] {
        guard let url = URL(string: "https://meowfacts.herokuapp.com/?count=1") else { return ["error"] }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else { return ["error"]}
        let result = try JSONDecoder().decode(TextModel.self, from: data)
        
        return result.data
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let texts: [String]
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(entry.texts, id: \.self) { text in
                Text(text)
                    .lineLimit(1)
                Divider()
            }
        }
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("위젯 예제")
        .description("랜덤 텍스트를 불러오는 위젯")
    }
}

//#Preview(as: .systemSmall) {
//    MyWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
