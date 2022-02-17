//
//  NewsModel.swift
//  StockApp
//
//  Created by Omotayo on 11/01/2022.
//

import Foundation


/// News Model
struct NewsModel: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
