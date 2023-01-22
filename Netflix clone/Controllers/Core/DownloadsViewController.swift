//
//  DownloadsViewController.swift
//  Netflix clone
//
//  Created by Varun Bagga on 26/12/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    
    private let downloadTable :UITableView = {
        let table = UITableView()
        table.register(TitleViewCell.self, forCellReuseIdentifier: TitleViewCell.identifier)
        
        return table
    }()
    
    private var titles :[TitleItem] = [TitleItem]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTable)
        
        downloadTable.dataSource = self
        downloadTable.delegate = self
        fetchLocalStorageForDownloads()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownloads()
        }
    }

    
    private func fetchLocalStorageForDownloads(){
        
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { result in
            switch result{
            case .success(let title):
                self.titles = title
                
                DispatchQueue.main.async {
                    self.downloadTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
}

extension DownloadsViewController : UITableViewDelegate,UITableViewDataSource{
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case.delete:
          
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { result in
                switch result{
                case .success():
                    print("Delete from database")
                case .failure(let error):
                    print(error)
                }
                self.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        default:
            break
            
        }
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
