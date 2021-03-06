//
//  NewsViewController.swift
//  StockApp
//
//  Created by Omotayo on 10/01/2022.
//

import UIKit
import SafariServices

/// Controller to show news
final class NewsViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Collection of models
    private var stories = [NewsModel]()
    
    /// instance of news type
    private let type: NewsType
    
    /// primary news view
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    /// Type of news
    enum NewsType {
        case topStories
        case company(symbol: String)
        
        /// title for given type
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
        
    /// Create VC with typ
    /// - Parameter type: news type
    init(type: NewsType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    
    /// Inherited init
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
    
    /// Sets up tableview
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Fetch news models
    private func fetchNews() {
        APICallsManager.shared.news(for: self.type) { result in
            switch result {
                case .success(let stories):
                    DispatchQueue.main.async {
                        self.stories = stories
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    /// Open a story in safari service
    /// - Parameter url: url to open
    private func open(url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate

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
        
        HapticManager.shared.vibrateForSelection()
        
        let story = stories[indexPath.row]
        guard let url = URL(string: story.url) else {
            presentFailedToOpenAlert()
            return
        }
        open(url: url)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier)
                as? NewsHeaderView else { return nil }
        headerView.configure(with: .init(title: self.type.title, shouldShowAddButton: false))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferedHeight
    }
    
    /// Present an alert to show an error occurred when opening story
    private func presentFailedToOpenAlert() {
        
        HapticManager.shared.vibrate(for: .error)
        
        let alert = UIAlertController(
            title: "Unable to Open URL",
            message: "We were unable to open the article.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
