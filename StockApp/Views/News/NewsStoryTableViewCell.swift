//
//  NewsTableViewCell.swift
//  StockApp
//
//  Created by Omotayo on 12/01/2022.
//

import UIKit
import SDWebImage

class NewsStoryTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: self)
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageUrl: URL?
        
        init(model: NewsModel) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = .string(from: model.datetime)
            self.imageUrl = URL(string: model.image)
        }
    }
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let storyImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .tertiarySystemBackground
        image.layer.cornerRadius = 6
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 8
        let margins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            storyImage.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 12),
            storyImage.widthAnchor.constraint(equalToConstant: imageSize),
            storyImage.heightAnchor.constraint(equalToConstant: imageSize),
            storyImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            
            sourceLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            sourceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            sourceLabel.trailingAnchor.constraint(equalTo: storyImage.leadingAnchor, constant: -8),
            
            headlineLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            headlineLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: storyImage.leadingAnchor, constant: -8),
            
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8)
        ])
        
//        sourceLabel.sizeToFit()
//        headlineLabel.sizeToFit()
//        storyImage.frame = CGRect(x: contentView.width - imageSize - 16, y: 4, width: imageSize, height: imageSize)
//        dateLabel.frame = CGRect(x: separatorInset.left, y: contentView.height - 40, width: availableWidth, height: 40)
//        sourceLabel.frame = CGRect(x: separatorInset.left, y: 4, width: availableWidth, height: sourceLabel.height)
//        headlineLabel.frame = CGRect(x: separatorInset.left, y: sourceLabel.bottom + 4, width: availableWidth, height: headlineLabel.height)
//
        // contentView.height - sourceLabel.bottom - dateLabel.height - 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImage.image = nil
    }
    
    public func configure(with model: ViewModel) {
        headlineLabel.text = model.headline
        sourceLabel.text = model.source
        dateLabel.text = model.dateString
        storyImage.sd_setImage(with: model.imageUrl, completed: nil)
//        storyImage.setImage(with: model.imageUrl)
    }
}
