//
//  WatchlistTableViewCell.swift
//  StockApp
//
//  Created by Omotayo on 25/01/2022.
//

import UIKit

/// Delegate to notify of cell events
protocol WatchlistTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

/// Table cell for watchlist item
final class WatchlistTableViewCell: UITableViewCell {

    /// Cell identifier
    static let identifier = String(describing: self)
    
    /// Deleage instance
    weak var delegate: WatchlistTableViewCellDelegate?
    
    /// Ideal cell height
    static let preferedHeight: CGFloat = 60
    
    /// Watchlist table cell view model
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String               // formatted
        let changeColor: UIColor        // red or green
        let changePercentage: String    // formatted
        let chartViewModel: StockChartView.ViewModel
    }
    
    // MARK: - UI Views
    
    /// symbol label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    /// Company name label
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    /// Price label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    /// Change in price label
    private let changeInPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    
    /// MiniChart View
    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.clipsToBounds = true
        chart.isUserInteractionEnabled = false
        return chart
    }()
    
    // MARK: - Overriden Functions
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews(
            symbolLabel,
            companyNameLabel,
            priceLabel,
            changeInPriceLabel,
            miniChartView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        symbolLabel.sizeToFit()
        companyNameLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeInPriceLabel.sizeToFit()

        let currentWidth = max(
            max(priceLabel.width, changeInPriceLabel.width),
            WatchListViewController.maxChangeWidth
        )

        if currentWidth > WatchListViewController.maxChangeWidth {
            WatchListViewController.maxChangeWidth = currentWidth
            delegate?.didUpdateMaxWidth()
        }
        
        // This get the y position to center both the symbol anc company name labels
        let yStartLeft: CGFloat = (contentView.height - symbolLabel.height - companyNameLabel.height) / 2
        let yStartRight: CGFloat = (contentView.height - priceLabel.height - changeInPriceLabel.height) / 2
        
        symbolLabel.frame = CGRect(
            x: separatorInset.left,
            y: yStartLeft,
            width: symbolLabel.width,
            height: symbolLabel.height
        )
        companyNameLabel.frame = CGRect(
            x: separatorInset.left,
            y: symbolLabel.bottom,
            width: contentView.width - miniChartView.width - priceLabel.width - 40,
            height: companyNameLabel.height
        )
        
        let xPoint = contentView.width - 10 - currentWidth
        priceLabel.frame = CGRect(
            x: xPoint,
            y: yStartRight,
            width: currentWidth,
            height: priceLabel.height
        )
        changeInPriceLabel.frame = CGRect(
            x: xPoint,
            y: priceLabel.bottom,
            width: currentWidth,
            height: changeInPriceLabel.height
        )
        
        miniChartView.frame = CGRect(
            x: priceLabel.left - (contentView.width / 3) - 5,
            y: 6,
            width: contentView.width / 3,
            height: contentView.height - 12
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyNameLabel.text = nil
        priceLabel.text = nil
        changeInPriceLabel.text = nil
        miniChartView.reset()
    }
    
    // MARK: - Public functions
    /// Configure view
    /// - Parameter viewModel: View viewModel
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyNameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeInPriceLabel.text = viewModel.changePercentage
        changeInPriceLabel.backgroundColor = viewModel.changeColor
        
        miniChartView.configure(with: viewModel.chartViewModel)
    }
    
}
