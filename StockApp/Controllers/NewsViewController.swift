//
//  NewsViewController.swift
//  StockApp
//
//  Created by Omotayo on 10/01/2022.
//

import UIKit

class NewsViewController: UIViewController {
    
    // MARK: - Properties
    private var stories = [NewsModel]()
//    private var stories = [
//        NewsModel(category: "General", datetime: "January 13, 2022" , headline: "The headline of this news is the apple content team", image: "", related: "", source: "CNBC", summary: "", url: "")
//    ]
    
    private let type: NewsType
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - News type enum
    enum NewsType {
        case topStories
        case company(symbol: String)
        
        var title: String {
            switch self {
                case .topStories:
                    return "Top Stories"
                case .company(let symbol):
                    return symbol.uppercased()
            }
        }
    }
    
    // MARK: - Initializers
    
    init(type: NewsType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchNews()
    }
    
    // MARK: - Private

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchNews() {
        
    }
    
    private func open(url: URL) {
        
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else { fatalError() }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open news story
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier)
                as? NewsHeaderView else { return nil }
        headerView.configure(with: .init(title: self.type.title, shouldShowAddButton: true))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferedHeight
    }
    
}
