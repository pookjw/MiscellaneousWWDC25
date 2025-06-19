//
//  ObservationDemoContentConfigurationViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

import UIKit
import Observation

final class ObservationDemoContentConfigurationViewController: UICollectionViewController {
    @ViewLoading private var cellReqgistration: UICollectionView.CellRegistration<UICollectionViewListCell, Int>
    private let viewModel = ViewModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: UICollectionLayoutListConfiguration(appearance: .insetGrouped))
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellReqgistration = .init(handler: { [viewModel] cell, indexPath, itemIdentifier in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = String(viewModel.count)
            cell.contentConfiguration = contentConfiguration
            
            cell.configurationUpdateHandler = { cell, state in
                var contentConfiguration = (cell as! UICollectionViewListCell).defaultContentConfiguration()
                contentConfiguration.text = String(viewModel.count)
                cell.contentConfiguration = contentConfiguration
            }
        })
        
        let menuBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "filemenu.and.selection"), target: nil, action: nil, menu: makeMenu())
        navigationItem.rightBarButtonItem = menuBarButtonItem
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellReqgistration, for: indexPath, item: indexPath.item)
    }
    
    private func makeMenu() -> UIMenu {
        let element = UIDeferredMenuElement.uncached { [viewModel] completion in
            let incrementAction = UIAction(title: "Increment", image: UIImage(systemName: "plus")) { _ in
                viewModel.count += 1
            }
            
            let decrementAction = UIAction(title: "Decrement", image: UIImage(systemName: "minus")) { _ in
                viewModel.count -= 1
            }
            
            completion([incrementAction, decrementAction])
        }
        
        return UIMenu(children: [element])
    }
}

extension ObservationDemoContentConfigurationViewController {
    @Observable
    fileprivate final class ViewModel {
        var count = 0
    }
}
