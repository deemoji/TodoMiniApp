//
//  TodoPreviewViewController.swift
//  
//
//  Created by Дмитрий Мартьянов on 08.09.2024.
//

import UIKit

public final class TodoPreviewViewController: UIViewController {
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Посмотреть список дел."
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let colorForBackground: UIColor
    
    public init(_ color: UIColor) {
        colorForBackground = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = colorForBackground
        view.addSubview(previewLabel)
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            previewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
