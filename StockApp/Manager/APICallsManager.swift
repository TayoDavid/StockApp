//
//  APICallsManager.swift
//  StockApp
//
//  Created by Omotayo on 07/01/2022.
//

import Foundation


/// Object to manage api calls
final class APICallsManager {
    
    /// Singleton
    public static let shared = APICallsManager()
    
    /// Constant
    private struct Constants {
        static let apiKey = "c7cahfqad3idhma676l0"
        static let sandboxApiKey = "sandbox_c7cahfqad3idhma676lg"
        static let baseUrl = "https://finnhub.io/api/v1/"
        
        static let day: TimeInterval = 3600 * 24
        static let today = Date()
        static let oneMonthBack = today.addingTimeInterval(-(Constants.day * 30))
    }

    // MARK: - Private
    
    
    /// API Endpoint
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
    }
    
    /// API Error
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    /// Construct URL object for endpoint
    /// - Parameters:
    ///   - endpoint: Endpoint to construct
    ///   - queryParams: Additional query parameter
    /// - Returns: Optional URL
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        
        // Add any param if available
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert query items to suffix string
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        urlString += "?" + queryString

//        print("\n\(urlString)\n")       // REMOVE THIS LATER
        
        return URL(string: urlString)
    }
    
    
    /// Perform api calls
    /// - Parameters:
    ///   - url: URL to call
    ///   - expectiong: Type we expect to decode to
    ///   - completion: Callback for result
    private func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Public
    
    
    /// Search for a company
    /// - Parameters:
    ///    - query: Query string (symbol or name)
    ///    - completion: Callback for result
    public func search(query: String, completion: @escaping(Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) else { return }
        
        request(
            url: url(for: .search, queryParams: ["q" : safeQuery]),
            expecting: SearchResponse.self,
            completion: completion
        )
    }
    
    
    /// Get news of type
    /// - Parameters:
    ///    - type: Company or top stories
    ///    - completion: Callback for result
    public func news(for type: NewsViewController.NewsType, completion: @escaping (Result<[NewsModel], Error>) -> Void) {
        switch type {
            case .topStories:
                request(
                    url: url(for: .topStories, queryParams: ["category" : "general"]),
                    expecting: [NewsModel].self,
                    completion: completion
                )
            case .company(let symbol):
                request(
                    url: url(
                        for: .companyNews,
                           queryParams: [
                            "symbol": symbol,
                            "from": DateFormatter.newsDateFormatter.string(from: Constants.oneMonthBack),
                            "to": DateFormatter.newsDateFormatter.string(from: Constants.today)
                           ]
                    ),
                    expecting: [NewsModel].self,
                    completion: completion
                )
                
        }
    }
    
    
    /// Get market data for a company
    /// - Parameters:
    ///    - symbol: Given symbol
    ///    - numberOfDays: Number of days back from today
    ///    - completion: Callback for result
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        let today = Date().addingTimeInterval(-(Constants.day))
        let todayTimeInterval = Int(today.timeIntervalSince1970)
        let prior = Constants.today.addingTimeInterval(-(Constants.day * numberOfDays))
        let priorTimeInterval = Int(prior.timeIntervalSince1970)
        let url = url(
            for: .marketData,
            queryParams: [
                "symbol": symbol,
                "resolution": "1",
                "from": "\(priorTimeInterval)",
                "to": "\(todayTimeInterval)"
            ]
        )
        
        request(url: url, expecting: MarketDataResponse.self, completion: completion)
    }
    
    
    
    /// Get financial metrics
    /// - Parameters:
    ///   - symbol: Symbol or company
    ///   - completion: Callback for result
    public func financialMetrics(for symbol: String, completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void) {
        let url = url(for: .financials, queryParams: ["symbol" : symbol, "metric": "all"])
        request(url: url, expecting: FinancialMetricsResponse.self, completion: completion)
    }
}
