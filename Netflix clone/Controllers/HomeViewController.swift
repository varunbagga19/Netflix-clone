//
//  ViewController.swift
//  Netflix clone
//
//  Created by Varun Bagga on 26/12/22.
//

import UIKit

class HomeViewController: UIViewController  {
   
    
    
    
    let sectionsTitle:[String] = ["Trending Movies","Popular","Trending TV","Upcoming Movies","Top Rated"]
    
    //1.) Making a Computed property of UITableView which show item in table of rows
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
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        //tableHeaderView expects a UIView
        homeFeedTable.tableHeaderView = headerView
        
        
        configureNavBar()
        
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        
    }
    
    
    
    //function for giving header title to the section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitle[section]
    }
}
