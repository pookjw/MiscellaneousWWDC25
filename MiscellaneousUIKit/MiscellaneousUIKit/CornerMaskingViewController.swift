//
//  CornerMaskingViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

import UIKit
import UIKitPrivate

final class CornerMaskingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let greenView = UIView()
        greenView.backgroundColor = .systemGreen
        greenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greenView)
        NSLayoutConstraint.activate([
            greenView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            greenView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            greenView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            greenView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
        greenView.cornerMaskingConfiguration = .fixed(50)
        
        let blueView = UIView()
        blueView.backgroundColor = .systemBlue
        blueView.translatesAutoresizingMaskIntoConstraints = false
        greenView.addSubview(blueView)
        NSLayoutConstraint.activate([
            blueView.topAnchor.constraint(equalTo: greenView.topAnchor),
            blueView.leadingAnchor.constraint(equalTo: greenView.leadingAnchor),
            blueView.widthAnchor.constraint(equalTo: greenView.widthAnchor, multiplier: 0.6),
            blueView.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.3)
        ])
        blueView.cornerMaskingConfiguration = .containerConcentric
        
        let redView = UIView()
        redView.backgroundColor = .systemRed
        redView.translatesAutoresizingMaskIntoConstraints = false
        greenView.addSubview(redView)
        NSLayoutConstraint.activate([
            redView.bottomAnchor.constraint(equalTo: greenView.bottomAnchor, constant: -20),
            redView.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 20),
            redView.widthAnchor.constraint(equalTo: greenView.widthAnchor, multiplier: 0.6),
            redView.heightAnchor.constraint(equalTo: greenView.heightAnchor, multiplier: 0.3)
        ])
        redView.cornerMaskingConfiguration = .containerConcentric
    }
}
