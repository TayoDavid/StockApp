//
//  StockAppTests.swift
//  StockAppTests
//
//  Created by Omotayo on 17/02/2022.
//

@testable import StockApp

import XCTest

class StockAppTests: XCTestCase {
    
    func testCandleStickDataConversion() {
        let doubles: [Double] = Array(repeating: 12.2, count: 10)
        var timestamps: [TimeInterval] = []
        
        for x in 0..<12 {
            let timestamp = Date().addingTimeInterval(3600 * TimeInterval(x)).timeIntervalSince1970
            timestamps.append(timestamp)
        }
        
        timestamps.shuffle()
        
        let marketData = MarketDataResponse(
            open: doubles,
            close: doubles,
            high: doubles,
            low: doubles,
            status: "success",
            timestamps: timestamps
        )
        
        let candleSticks = marketData.candleSticks
        
        XCTAssertEqual(candleSticks.count, marketData.open.count)
        XCTAssertEqual(candleSticks.count, marketData.close.count)
        XCTAssertEqual(candleSticks.count, marketData.high.count)
        XCTAssertEqual(candleSticks.count, marketData.low.count)
//        XCTAssertEqual(candleSticks.count, marketData.timestamps.count)
        
        // Verify sort
        let dates = candleSticks.map { $0.date }
        for x in 0..<dates.count - 1 {
            let current = dates[x]
            let next = dates[x + 1]
            XCTAssertTrue(current > next, "Current date: \(current) shouldn't be less than next date: \(next) ")
        }
        
    }
    
}
