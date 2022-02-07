//
//  StockDetailsViewController.swift
//  StockApp
//
//  Created by Omotayo on 06/01/2022.
//

import UIKit
import SafariServices

class StockDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let symbol: String
    private let companyName: String
    private var candleStickData: [CandleStick]
    private var newsStories: [NewsModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Init
    
    init(symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle error
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = companyName
        setUpCloseButton()
        setUpTable()
        fetchFinancialData()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width * 0.7) + 100))
    }
    
    private func fetchFinancialData() {
        // Fetch candle stick if needed
        
        // Fetch financial metrics
        
        renderChart()
    }
    
    private func fetchNews() {
        APICallsManager.shared.news(for: .company(symbol: symbol)) { [weak self] result in
            switch result {
                case .success(let stories):
                    DispatchQueue.main.async {
                        self?.newsStories = stories
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func renderChart() {
        
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as! NewsStoryTableViewCell
        cell.configure(with: .init(model: newsStories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView
        else { return nil }
        header.delegate = self
        header.configure(with:
                    .init(
                        title: symbol.uppercased(),
                        shouldShowAddButton: !PersistenceManager.shared.watchlistContains(symbol: symbol)
                    )
        )
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: newsStories[indexPath.row].url) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

extension StockDetailsViewController: NewsHeaderViewDelegate {
    func didTapNewsHeaderViewAddButton(_ headerView: NewsHeaderView) {
        // Add to watchlist
        headerView.button.isHidden = true
        PersistenceManager.shared.addToWatchList(symbol: self.symbol, companyName: self.companyName)
        
        let alert = UIAlertController(
            title: "Added to watchlist",
            message: "We've added \(self.companyName) to your watchlist.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
