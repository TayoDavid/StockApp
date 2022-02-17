//
//  SearchResultTableViewCell.swift
//  StockApp
//
//  Created by Omotayo on 07/01/2022.
//

import UIKit

/// Tableviece cell for search result
final class SearchResultTableViewCell: UITableViewCell {
    
    /// cell identifier
    static let identifier = String(describing: self)

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
