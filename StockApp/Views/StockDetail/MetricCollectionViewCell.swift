//
//  MetricCollectionViewCell.swift
//  StockApp
//
//  Created by Omotayo on 08/02/2022.
//

import UIKit

/// Metric Table cell
class MetricCollectionViewCell: UICollectionViewCell {
    
    /// Cell identifier
    static let identifier = String(describing: self)
    
    /// Cell viewModel
    struct ViewModel {
        let name: String
        let value: String
    }
    
    /// Name label
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// Value label
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubviews(nameLabel, valueLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        valueLabel.sizeToFit()
        
        nameLabel.frame = CGRect(x: 3, y: 0, width: nameLabel.width, height: nameLabel.height)
        valueLabel.frame = CGRect(x: nameLabel.width + 3, y: 0, width: valueLabel.width, height: valueLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: View's viewModel
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.value
    }
}
