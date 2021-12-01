//
//  ViewController.swift
//  News App
//
//  Created by Admin on 5/15/21.
//

import UIKit
// TODO: 20
import SafariServices

// TableView
// Custom Cell
// API Caller
// Open the News Story
// Search for News Stories

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // TODO: 4
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    // TODO: 24
    private let searchVC = UISearchController(searchResultsController: nil)
    
    // TODO: 11
    private var viewModels = [NewsTableViewCellViewModel]()
    
    // TODO: 19
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        // TODO: 5
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTopStories()
        createSearchBar()
    }
    
    private func fetchTopStories() {
        // TODO: 3
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            //case .success(let response):
            
            case .success(let articles):
                // TODO: 18
                self?.articles = articles
                // TODO: 13
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "N/A",
                                               imageURL: URL(string: $0.urlToImage ?? ""
                                               ))
                    })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // TODO: 23
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    // TODO: 7
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // TODO: 6
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        //cell.textLabel?.text = "Hello News" this cell gonig to be as down below
        cell.confugure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: 17
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    // TODO: 14
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    // TODO: 25
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            //case .success(let response):
            
            case .success(let articles):
                // TODO: 18
                self?.articles = articles
                // TODO: 13
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "N/A",
                                               imageURL: URL(string: $0.urlToImage ?? ""
                                               ))
                    })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

