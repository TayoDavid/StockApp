//
//  StockChartView.swift
//  StockApp
//
//  Created by Omotayo on 25/01/2022.
//

import UIKit

class StockChartView: UIView {
    
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func reset() {
        // Reset view
    }
    
    func configure(with viewModel: ViewModel) {
        
    }
}
