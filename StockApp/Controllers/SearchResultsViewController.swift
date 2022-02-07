//
//  SearchResultsViewController.swift
//  StockApp
//
//  Created by Omotayo on 06/01/2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelect(searchResult: SearchResult)
}

class SearchResultsViewController: UIViewController {

    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var results: [SearchResult] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register a cell
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
 
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with results: [SearchResult]) {
        self.results = results
        tableView.isHidden = results.isEmpty
        tableView.reloadData()
    }

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier,
                                                 for: indexPath) as! SearchResultTableViewCell
        
        let result = results[indexPath.row]
    
        cell.textLabel?.text = result.displaySymbol
        cell.detailTextLabel?.text = result.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = results[indexPath.row]
        delegate?.didSelect(searchResult: result)
    }
}
