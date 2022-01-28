
//
//  ViewController.swift
//  StockApp
//
//  Created by Omotayo on 06/01/2022.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
    
    private var searchTimer: Timer?
    
    private var watchlistMap: [String: [CandleStick]] = [:]
    
    private var viewModels: [WatchlistTableViewCell.ViewModel] = []
    
    static var maxChangeWidth: CGFloat = 0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WatchlistTableViewCell.self, forCellReuseIdentifier: WatchlistTableViewCell.identifier)
        return tableView
    }()
    
    private var panel: FloatingPanelController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTitleView()
        setUpWatchlistTableView()
        fetchWatchlistData()
        setUpSearchController()
        setUpFloatingPanel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    private func setUpTitleView() {
        let titleView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: navigationController?.navigationBar.height ?? 100)
        )
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
        label.text = "Stocks App"
        label.font = .systemFont(ofSize: 32, weight: .medium)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    private func setUpWatchlistTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchList
        
        let group = DispatchGroup()
        
        for symbol in symbols {
            group.enter()
            APICallsManager.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                    case .success(let data):
                        let candleSticks = data.candleSticks
                        self?.watchlistMap[symbol] = candleSticks
                    case .failure(let error):
                        print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    private func createViewModels() {
        var viewModels = [WatchlistTableViewCell.ViewModel]()
        
        for (symbol, candleSticks) in watchlistMap {
            let changePercentage = getChangePercentage(symbol: symbol, for: candleSticks)
            
            viewModels.append(
                .init(
                    symbol: symbol,
                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                    price: getLatestClosingPrice(from: candleSticks),
                    changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
                    changePercentage: .percentage(from: changePercentage),
                    chartViewModel: .init(data: candleSticks.reversed().map { $0.close }, showLegend: false, showAxis: false)
                )
            )
        }
        
        self.viewModels = viewModels
    }
    
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else { return "" }
        return .formatted(from: closingPrice)
    }
    
    private func getChangePercentage(symbol: String, for data: [CandleStick]) -> Double {
        let latestDate = data[0].date
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: {
                  !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
              })?.close else {
                  return 0
              }
        
//        print("\(symbol): Current (\(data[0].date): \(latestClose) | Prior: \(priorClose)")
        
        let diff = 1 - (priorClose/latestClose)
//        print("\(symbol): \(diff)")
        return diff
    }
    
    private func setUpSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    private func setUpFloatingPanel() {
        let topStoriesVC = NewsViewController(type: .topStories)
        panel = FloatingPanelController()
        panel?.surfaceView.backgroundColor = .secondarySystemBackground
        panel?.set(contentViewController: topStoriesVC)
        panel?.delegate = self
        panel?.track(scrollView: topStoriesVC.tableView)
        panel?.addPanel(toParent: self)
    }

}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WatchlistTableViewCell.identifier,
            for: indexPath) as? WatchlistTableViewCell else {
            fatalError("Unable to dequeue cell!")
        }
        cell.delegate = self
        cell.configure(with: viewModels[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchlistTableViewCell.preferedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
                let resultVC = searchController.searchResultsController as? SearchResultsViewController,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        // Reset timer
        searchTimer?.invalidate()
        
        // Optimize to reduce number of searches for when user stops typing and kick off new timer
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { _ in
            // Call API to search
            APICallsManager.shared.search(query: query) { result in
                switch result {
                    case .success(let response):
                        DispatchQueue.main.async {
                            resultVC.update(with: response.result)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            resultVC.update(with: [])
                        }
                        print(error)
                }
            }
        })
    }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func didSelect(searchResult result: SearchResult) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        // Present stock details for given selection
        let vc = StockDetailsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = result.description
        present(navVC, animated: true)
    }
}

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListViewController: WatchlistTableViewCellDelegate {
    func didUpdateMaxWidth() {
        tableView.reloadData()
    }
}
