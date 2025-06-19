//
//  ObservationDemoViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

import UIKit
import Observation

final class ObservationDemoViewController: UIViewController {
    private let viewModel = ViewModel()
    @ViewLoading private var label: UILabel
    private var updateMode = UpdateMode.viewWillLayoutSubviews
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: view.bounds)
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .extraLargeTitle)
        label.backgroundColor = .systemBackground
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(label)
        
        let menuBarButtonItem = UIBarButtonItem(title: "Menu", image: UIImage(systemName: "filemenu.and.selection"), target: nil, action: nil, menu: makeMenu())
        navigationItem.rightBarButtonItem = menuBarButtonItem
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if updateMode == .viewWillLayoutSubviews {
            label.text = "\(viewModel.count) (\(#function))"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if updateMode == .viewDidLayoutSubviews {
            label.text = "\(viewModel.count) (\(#function))"
        }
    }
    
    override func updateProperties() {
        super.updateProperties()
        
        if updateMode == .updateProperties {
            label.text = "\(viewModel.count) (\(#function))"
        }
    }
    
    private func makeMenu() -> UIMenu {
        let element = UIDeferredMenuElement.uncached { [viewModel, weak self] completion in
            let incrementAction = UIAction(title: "Increment", image: UIImage(systemName: "plus")) { _ in
                viewModel.count += 1
            }
            
            let decrementAction = UIAction(title: "Decrement", image: UIImage(systemName: "minus")) { _ in
                viewModel.count -= 1
            }
            
            let modesActions = UpdateMode
                .allCases
                .map { mode in
                    let action = UIAction(title: String(describing: mode)) { _ in
                        guard let self else { return }
                        self.updateMode = mode
                        self.setNeedsUpdateProperties()
                        self.view.setNeedsLayout()
                    }
                    
                    action.state = self?.updateMode == mode ? .on : .off
                    return action
                }
            let modesMenu = UIMenu(title: "Update Modes", children: modesActions)
            
            completion([incrementAction, decrementAction, modesMenu])
        }
        
        return UIMenu(children: [element])
    }
}

extension ObservationDemoViewController {
    @Observable
    fileprivate final class ViewModel {
        var count = 0
    }
    
    fileprivate enum UpdateMode: CaseIterable {
        case viewWillLayoutSubviews
        case viewDidLayoutSubviews
        case updateProperties
    }
}
