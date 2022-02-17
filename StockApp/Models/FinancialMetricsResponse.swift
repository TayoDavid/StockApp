//
//  FinancialMetricsResponse.swift
//  StockApp
//
//  Created by Omotayo on 08/02/2022.
//

import Foundation

/// Metrics response from API
struct FinancialMetricsResponse: Codable {
    let metric: Metrics
}
 
/// Financial metrics
struct Metrics: Codable {
    let beta: Float
    let tenDaysAverageTradingValue : Float
    let fiftyTwoWeekHigh : Double
    let fiftyTwoWeekLow : Double
    let fiftyTwoWeekLowDate : String 
    let fiftyTwoWeekPriceReturnDaily : Float
    
    enum CodingKeys: String, CodingKey {
        case beta
        case tenDaysAverageTradingValue = "10DayAverageTradingVolume"
        case fiftyTwoWeekHigh = "52WeekHigh"
        case fiftyTwoWeekLow = "52WeekLow"
        case fiftyTwoWeekLowDate = "52WeekLowDate"
        case fiftyTwoWeekPriceReturnDaily = "52WeekPriceReturnDaily"
    }
}

