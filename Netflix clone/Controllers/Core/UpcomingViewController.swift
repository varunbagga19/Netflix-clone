//
//  UpcomingViewController.swift
//  Netflix clone
//
//  Created by Varun Bagga on 26/12/22.
//

import UIKit

class UpcomingViewController: UIViewController {

    private let upcomingTable : UITableView = {
        let table = UITableView()
        table.register(TitleViewCell.self, forCellReuseIdentifier: TitleViewCell.identifier)
        
        return table
    }()
    
    private var titles :[Title] = [Title]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies {[weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }
    }
    
}
extension UpcomingViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: TitleViewCell.identifier, for: indexPath) as? TitleViewCell else{
            return UITableViewCell()
        }
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_title ?? "unknown", posterURL: titles[indexPath.row].poster_path ?? "unknown"))
        return cell
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
