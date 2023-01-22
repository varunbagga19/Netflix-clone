//
//  CollectionViewTableViewCell.swift
//  Netflix clone
//
//  Created by Varun Bagga on 26/12/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate:AnyObject{
    func collectionViewTableViewCellDidTapCell(_ cell:CollectionViewTableViewCell,viewModel:TitlePreviewViewModel)
}


class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      // contentView-:The content view of a UITableViewCell object is the default superview for content that the cell displays. If you want to customize cells by simply adding additional views, you should add them to the content view
      contentView.backgroundColor = .systemPink
      contentView.addSubview(collectionView)
      collectionView.delegate = self
      collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    //layoutSubviews() is a method of the UIView class that is called when a view's layout is about to be updated. This method is typically overridden by subclasses of UIView to make custom adjustments to the layout of their subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    public func configure(with titles : [Title]){
        self.titles = titles
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath : IndexPath){
        
        
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result{
            case .success():
                print("Downloaded to databse")
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
         return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else{
            return
        }
        APICaller.shared.getMovie(with: titleName) {[weak self] result in
            switch result{
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                guard let titleOverView = title?.overview else{
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName,
                                                      youtubeView: videoElement,
                                                      titleOverview: titleOverView)
                guard let strongSelf = self else{ 
                    return
                }
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf,
                                                                viewModel:viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download"){ _ in
//                print("Size of index path\(indexPaths[0])")
                self.downloadTitleAt(indexPath: indexPaths[0])
                
                
            }
            return UIMenu(options: .displayInline,children: [downloadAction])
        }
        return config
    }
    
}
