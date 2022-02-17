//
//  NewsHeaderView.swift
//  StockApp
//
//  Created by Omotayo on 10/01/2022.
//

import UIKit

/// Delegate to notify of header events
protocol NewsHeaderViewDelegate {
    /// Notify user tapped header button
    /// - Parameter header: headerView description
    func didTapNewsHeaderViewAddButton(_ headerView: NewsHeaderView)
}


/// Tableview header for news
final class NewsHeaderView: UITableViewHeaderFooterView {
    
    /// Header identifier
    static let identifier = String(describing: self)
    
    /// Ideal height of header
    static let preferedHeight: CGFloat = 56
    
    /// Delegate instance for event
    var delegate: NewsHeaderViewDelegate?
    
    /// Viewmodel for header view
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    // MARK: - Private
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    let button: UIButton = {
       let button = UIButton()
        button.setTitle("+ Watchlist", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label, button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width - 28, height: contentView.height)
        button.sizeToFit()
        button.frame = CGRect(x: contentView.width - button.width - 16, y: (contentView.height - button.height) / 2, width: button.width + 8, height: button.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    /// Configure view
    /// - Parameter model: View model
    public func configure(with model: ViewModel) {
        label.text = model.title
        button.isHidden = !model.shouldShowAddButton
    }
    
    /// Handle button tap
    @objc private func didTapButton() {
        delegate?.didTapNewsHeaderViewAddButton(self)
    }
}
