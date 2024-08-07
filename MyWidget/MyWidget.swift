//
//  MyWidget.swift
//  MyWidget
//
//  Created by 최주리 on 7/26/24.
//

import WidgetKit
import SwiftUI
import UIKit

struct Provider: AppIntentTimelineProvider {
    let imageCache = NSCache<NSString, UIImage>()
    
    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), texts: ["Empty"])
        SimpleEntry(date: Date(), uiImage: UIImage(), url: "")
    }
    
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), texts: ["Empty"])
        
        SimpleEntry(date: Date(), uiImage: UIImage(), url: "")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
//        do {
//            let texts = try await getTexts()
//            let currentDate = Date()
//            let entry = SimpleEntry(date: currentDate, texts: texts)
//            let nextRefresh = Calendar.current.date(byAdding: .second, value: 30, to: currentDate)!
//            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
//
//            return timeline
//        } catch {
//            print("error!!!!!\(error)")
//        }
        
        do {
            let result = try await getPhoto()
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, uiImage: result.0, url: result.1 ?? "")
            let nextRefresh = Calendar.current.date(byAdding: .second, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            
            return timeline
            
        } catch {
            print("error \(error)")
        }
        
        return Timeline(entries: [], policy: .atEnd)
    }
    
//    func getTexts() async throws -> [String] {
//        guard let url = URL(string: "https://meowfacts.herokuapp.com/?count=1") else { return ["error"] }
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        guard let httpResponse = response as? HTTPURLResponse else { return ["error"]}
//        let result = try JSONDecoder().decode(TextModel.self, from: data)
//        
//        return result.data
//        
//    }
    
    func getPhoto() async throws -> (UIImage, String?) {
        guard
            let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=texas&tagmode=any&format=json&nojsoncallback=1")
        else { return (UIImage(), "") }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let model = try JSONDecoder().decode(PhotoModel.self, from: data)
        let urlString = model.items.first?.media.m
        if let image = imageCache.object(forKey: urlString! as NSString) {
            return (image, urlString)
        } else {
            guard
                let url = URL(string: urlString ?? ""),
                let data = try? Data(contentsOf: url),
                let uiImage = UIImage(data: data)
            else { return (UIImage(), "") }
            
            imageCache.setObject(uiImage, forKey: urlString! as NSString)
            
            return (uiImage, urlString)
        }
    }
}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let texts: [String]
//}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let uiImage: UIImage
    let url: String
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
//            ForEach(entry.texts, id: \.self) { text in
//                Text(text)
//                    .lineLimit(1)
//                    .widgetURL(URL(string: getURL("widget://deeplink?text=\(text)")))
//                Divider()
//            }
            
            Image(uiImage: entry.uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .widgetURL(URL(string: getURL("widget://deeplink?url=\(entry.url)")))
        }
    }
    
    private func getURL(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
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
