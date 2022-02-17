import Foundation
import UIKit

// MARK: - Frame

extension UIView {
    // MARK: - UIVIEW extension properties
    
    /// Weight of view
    var width: CGFloat {
        frame.size.width
    }
    
    /// Height of view
    var height: CGFloat {
        frame.size.height
    }
    
    /// Left edge of view
    var left: CGFloat {
        frame.origin.x
    }
    
    /// Right edge of view
    var right: CGFloat {
        left + width
    }
    
    /// Top edge of view
    var top: CGFloat {
        frame.origin.y
    }
    
    /// Bottom edge of view
    var bottom: CGFloat {
        top + height
    }
    
    /// Adds multiple subviews
    /// - Parameter views: Collection of views
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

// MARK: - UIImageView => To manually set web image.
extension UIImageView {
    /// Sets image from remote url
    /// - Parameter url: UIL to fetch from
    func setImage(with url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}

// MARK: - String

extension String {
    /// Create string from time interval
    /// - Parameter timeInterval: TimeInterval since 1970
    /// - Returns: Formated string
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
    
    /// Percentage formatted string
    /// - Parameter double: Double to format
    /// - Returns: String in Percentage format
    static func percentage(from double: Double) -> String {
        let formatter = NumberFormatter.percentFormatter
        return formatter.string(from: NSNumber(value: double)) ?? "\(double)"
    }
    
    /// Format number to string
    /// - Parameter number: number to format
    /// - Returns: Formated string
    static func formatted(from number: Double) -> String {
        let formatter = NumberFormatter.numberFormatter
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

// MARK: - Dateformatter

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let prettyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - NumberFormatter

extension NumberFormatter {
    /// Formater for percent style
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    /// Formater for decimal style
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

// MARK: - Notification

extension Notification.Name {
    
    static let didAddToWatchlist = Notification.Name("didAddToWatchlist")
}

// MARK: - CandleStick Sorting
extension Array where Element == CandleStick {
    
    /// Gets change percentage for symbol data
    /// - Parameters:
    ///   - data: collection of data
    /// - Returns: Double percentage
    func getChangePercentage() -> Double {
        let latestDate = self[0].date
        guard let latestClose = self.first?.close,
              let priorClose = self.first(where: {
                  !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
              })?.close else {
                  return 0
              }
        
        let diff = 1 - (priorClose/latestClose)
        return diff
    }
}
