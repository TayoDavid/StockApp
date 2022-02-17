//
//  SearchResponse.swift
//  StockApp
//
//  Created by Omotayo on 08/01/2022.
//

import Foundation

/// API response to search
struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

/// A single search result
struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
