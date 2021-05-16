//
//  Models.swift
//  News App
//
//  Created by Admin on 5/15/21.
//

import Foundation

// TODO: 2
struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String       // for this property we need to convert to DateFormatter
}

struct Source: Codable {
    let name: String
}
