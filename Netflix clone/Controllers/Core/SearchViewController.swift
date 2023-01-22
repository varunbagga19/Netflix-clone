//
//  SearchViewController.swift
//  Netflix clone
//
//  Created by Varun Bagga on 26/12/22.
//

import UIKit

class SearchViewController: UIViewController {

    
    private var titles:[Title] = [Title]()
    
    private let discoverTable :UITableView = {
        let table = UITableView()
        table.register(TitleViewCell.self, forCellReuseIdentifier: TitleViewCell.identifier)
        return table
    }()
    
    private let searchController:UISearchController = {
//     UISearchController(searchResultsController: SearchResultsViewController())-:   Creates and returns a search controller with the specified view controller for displaying the results
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(discoverTable)
        discoverTable.dataSource = self
        discoverTable.delegate = self
        navigationItem.searchController = searchController
        fetchDiscoverMovies()
        // searchResultsUpdater :- The object responsible for updating the contents of the search results controller
        searchController.searchResultsUpdater = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { result in
            switch result{
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - DATA HAndling
extension SearchViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleViewCell.identifier, for: indexPath) as? TitleViewCell else{
            return UITableViewCell()
        }
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_title ?? "Unknown", posterURL: titles[indexPath.row].poster_path ?? "Unknown"))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title else{
            return
        }
        
        APICaller.shared.getMovie(with: titleName) { result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                     vc.configure(with: TitlePreviewViewModel(title:titleName ,
                                                              youtubeView: videoElement,
                                                              titleOverview: title.overview ?? "unknown"))
                     self.navigationController?.pushViewController(vc, animated: true)
                    self.navigationController?.navigationBar.tintColor = .white
                }
              
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
//MARK: - SearchView COntroller

extension SearchViewController:UISearchResultsUpdating,SearchResultsViewControllerDelegate{
    
    
    
    func SearchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {[weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else{
              return
        }
        resultsController.delegate = self
        
        print("\(query) before calling api " )
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
