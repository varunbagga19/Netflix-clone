//
//  ViewController.swift
//  Netflix clone
//
//  Created by Varun Bagga on 26/12/22.
//

import UIKit




enum Sections:Int{
    
    case TrendingMOvies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController  {
   
    
    
    
    let sectionsTitle:[String] = ["Trending Movies","Trending TV","Popular","Upcoming Movies","Top Rated"]
    
    //1.) Making a Computed property of UITableView which show item in table of rows
    
    private var randomTrendingMOvies : Title?
    
    private var headerView:HeroHeaderUIView?
    
    private let homeFeedTable:UITableView = {
        
        //UITableView(style:.grouped)-: A table view where sections have distinct groups of rows.Section headers and footers don’t float when the table view scrolls
        //The table view's style is set to .grouped, so it will display the cells in groups with a default header and footer.
        
        
        let table = UITableView(frame: .zero, style: .grouped)
        
        //registering our cell that we will use
        
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        // assinging delegate and data source property to the viewController to handle the data population of the the table view
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        //headerView:UIView
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        //tableHeaderView expects a UIView
        homeFeedTable.tableHeaderView = headerView
        configureNavBar()
        ConfigureHeroHeaderView()
        
    }
    
    private func ConfigureHeroHeaderView(){
        
        APICaller.shared.getTrendingMovies {[weak self] result in
            switch result{
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMOvies = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "Unknown",
                                                                 posterURL: selectedTitle?.poster_path ?? "Unknown"))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo1")
        //force ios system to use image as it is
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
//        navigationController?.hidesBarsOnSwipe = true
        
    }
    //viewDidLayoutSubviews() is a method of the UIViewController class that is called after the view controller's view has finished laying out its subviews. This method is typically used to make final adjustments to the layout of a view after all of its subviews have been positioned.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}
//MARK: - DATA POPULATION HANDLING
extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier,for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        
        cell.delegate = self
        
        
        switch indexPath.section {
        case Sections.TrendingMOvies.rawValue:
            APICaller.shared.getTrendingMovies { result in
               switch result{
               case .success(let titles):
                   cell.configure(with: titles)
               case .failure(let error):
                   print(error.localizedDescription)
               }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result{
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    // returns height for the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // table view inherits scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let Offset = scrollView.contentOffset.y+defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -Offset))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{
            return
        }
        header.textLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x+20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        
    }
    
    
    
    //function for giving header title to the section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitle[section]
    }
}

extension HomeViewController:CollectionViewTableViewCellDelegate{
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = TitlePreviewViewController()
            vc.configure(with:viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
