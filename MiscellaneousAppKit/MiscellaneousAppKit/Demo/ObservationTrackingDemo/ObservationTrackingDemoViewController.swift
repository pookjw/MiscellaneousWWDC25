//
//  ObservationTrackingDemoViewController.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/26/25.
//

import Cocoa
import Observation

final class ObservationTrackingDemoViewController: NSViewController {
    @ViewLoading private var splitView: NSSplitView
    @ViewLoading private var configurationView: ConfigurationView
    @ViewLoading private var demoView: DemoView
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitView = NSSplitView()
        
        configurationView = ConfigurationView()
        configurationView.delegate = self
        
        demoView = DemoView(viewModel: viewModel)
        
        splitView.addArrangedSubview(configurationView)
        splitView.addArrangedSubview(demoView)
        splitView.isVertical = true
        splitView.frame = view.bounds
        splitView.autoresizingMask = [.width, .height]
        view.addSubview(splitView)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let stepperItemModel = ConfigurationItemModel.stepperItem(identifier: "Stepper") { [viewModel] itemModel in
            ConfigurationStepperDescription(
                value: Double(viewModel.count),
                minValue: -100,
                maxValue: 100,
                stepValue: 1,
                continuous: true,
                autorepeat: true,
                valueWraps: true
            )
        }
        
        let modeItemModel = ConfigurationItemModel.popUpButtonItem(identifier: "Mode") { [viewModel] itemModel in
            let titles: [ConfigurationPopUpButtonDescription.Title] = Mode
                .allCases
                .map { mode in
                    if viewModel.mode == mode {
                        return .primarySelected(mode.rawValue)
                    } else {
                        return .unselected(mode.rawValue)
                    }
                }
            
            return ConfigurationPopUpButtonDescription(titles: titles)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<NSNull, ConfigurationItemModel>()
        snapshot.appendSections([NSNull()])
        snapshot.appendItems([stepperItemModel, modeItemModel], toSection: NSNull())
        configurationView.apply(snapshot, animatingDifferences: true)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if viewModel.mode == .updateViewConstraints {
            demoView.textField.stringValue = "\(viewModel.count) (\(#function)"
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        if viewModel.mode == .viewDidLayout {
            demoView.textField.stringValue = "\(viewModel.count) (\(#function)"
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        if viewModel.mode == .viewWillLayout {
            demoView.textField.stringValue = "\(viewModel.count) (\(#function)"
        }
    }
}

extension ObservationTrackingDemoViewController: ConfigurationViewDelegate {
    func configurationView(_ configurationView: ConfigurationView, didTriggerActionWith itemModel: ConfigurationItemModel, newValue: Any?) -> Bool {
        if itemModel.identifier == "Stepper" {
            viewModel.count = Int(newValue as! Double)
        } else if itemModel.identifier == "Mode" {
            viewModel.mode = Mode(rawValue: newValue as! String)!
        } else {
            fatalError()
        }
        
        return true
    }
    
    var shouldShowReloadButton: Bool {
        false
    }
    
    func didTriggerReloadButton(_ configurationView: ConfigurationView) {
        
    }
}

extension ObservationTrackingDemoViewController {
    @Observable
    fileprivate final class ViewModel {
        var count = 0
        var mode: Mode = .updateViewConstraints
    }
    
    fileprivate enum Mode: String, CaseIterable {
        case drawRect
        case layout
        case updateConstraints
        case updateLayer
        case updateViewConstraints
        case viewDidLayout
        case viewWillLayout
    }
}

extension ObservationTrackingDemoViewController {
    fileprivate final class DemoView: NSView {
        private let viewModel: ViewModel
        let textField: NSTextField
        
        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            textField = NSTextField(wrappingLabelWithString: "")
            
            super.init(frame: .zero)
            
            addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
                textField.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
            ])
        }
        
        override var wantsUpdateLayer: Bool {
            true
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ dirtyRect: NSRect) {
            if viewModel.mode == .drawRect {
                textField.stringValue = "\(viewModel.count) (\(#function)"
            }
            
            super.draw(dirtyRect)
        }
        
        override func layout() {
            if viewModel.mode == .layout {
                textField.stringValue = "\(viewModel.count) (\(#function)"
            }
            
            super.layout()
        }
        
        override func updateConstraints() {
            if viewModel.mode == .updateConstraints {
                textField.stringValue = "\(viewModel.count) (\(#function)"
            }
            
            super.updateConstraints()
        }
        
        override func updateLayer() {
            if viewModel.mode == .updateLayer {
                textField.stringValue = "\(viewModel.count) (\(#function)"
            }
            
            super.updateLayer()
        }
    }
}
