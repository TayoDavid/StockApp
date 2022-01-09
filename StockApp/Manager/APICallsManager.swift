//
//  APICallsManager.swift
//  StockApp
//
//  Created by Omotayo on 07/01/2022.
//

import Foundation

final class APICallsManager {
    
    static let shared = APICallsManager()
    
    private struct Constants {
        static let apiKey = "c7cahfqad3idhma676l0"
        static let sandboxApiKey = "sandbox_c7cahfqad3idhma676lg"
        static let baseUrl = "https://finnhub.io/api/v1/"
    }
    
//    private init() {}
    
    // MARK: - Public
    
    public func search(query: String, completion: @escaping(Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) else { return }
        
        request(
            url: url(for: .search, queryParams: ["q" : safeQuery]),
            expecting: SearchResponse.self,
            completion: completion
        )
    }

    // MARK: - Private
    
    private enum Endpoint: String {
        case search
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        // Add any param if available
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        // Convert query items to suffix string
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        urlString += "?" + queryString

//        print("\n\(urlString)\n")
        
        return URL(string: urlString)
    }
    
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
}
