//
//  PageModel.swift
//  SlidingIntroScreen
//
//  Created by Federico on 18/03/2022.
//

import Foundation
import SwiftUI

//struct Page: Identifiable, Equatable {
//    let id = UUID()
//    var name: String
//    var description: String
//    var imageUrl: String
//    var tag: Int
//    
//    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", imageUrl: "work", tag: 0)
//    
//    static var samplePages: [Page] = [
//        Page(name: "Mood", description: "Mood Memory Mapped: Where feelings find a home.", imageUrl: "cowork", tag: 0),
//        Page(name: "Memory", description: "Capture your travel journal, frame by frame. Explore with Memory Mood Mapped!", imageUrl: "work", tag: 1),
//        Page(name: "Map", description: "Navigate and explore the landscape of your life's journey, perfectly mapped.", imageUrl: "website", tag: 2),
//    ]
//}


struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    var backgroundColor: Color // Add this property for background color
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", imageUrl: "work", tag: 0, backgroundColor: .blue)
    
    static var samplePages: [Page] = [
        Page(name: "Mood", description: "Mood Memory Mapped: Where feelings find a home.", imageUrl: "Mood", tag: 0, backgroundColor: Color("Green")),
        Page(name: "Memory", description: "Capture your travel journal, frame by frame. Explore with Memory Mood Mapped!", imageUrl: "Memory", tag: 1, backgroundColor: Color("Purple")),
        Page(name: "Map", description: "Navigate and explore the landscape of your life's journey, perfectly mapped.", imageUrl: "Map", tag: 2, backgroundColor: Color("Orange")), 
    ]

}

