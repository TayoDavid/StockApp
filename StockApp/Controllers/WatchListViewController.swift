
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
    
    private var panel: FloatingPanelController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTitleView()
        setUpSearchController()
        setUpFloatingPanel()
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
        print("Did select \(result.displaySymbol)")
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
