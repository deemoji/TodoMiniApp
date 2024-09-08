//
//  TodoViewController.swift
//  
//
//  Created by Дмитрий Мартьянов on 07.09.2024.
//

import UIKit

public final class TodoViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить задание", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var tasks: [String] = []
    
    private let id: Int
    
    private let colorForButton: UIColor
    
    public init(id: Int, _ color: UIColor) {
        self.id = id
        self.colorForButton = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupTableView()
        loadTasks()
    }
    private func setupButton() {
        addButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        addButton.backgroundColor = colorForButton
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        
    }
    @objc private func addTask() {
        let alertController = UIAlertController(title: "Новая задача.", message: "Дайте название задачи.", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Например, выгулять собаку."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let text = alertController.textFields?.first?.text, !text.isEmpty {
                self?.tasks.append(text)
                self?.tableView.reloadData()
                self?.saveTasks()
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}

// MARK:  - UITableViewDataSource
extension TodoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.taskLabel.text = tasks[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveTasks()
        }
    }
}

// MARK: - UITableViewDelegate
extension TodoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.15
    }
}

// MARK: - Caching
extension TodoViewController {
    func loadTasks() {
        tasks = UserDefaults.standard.stringArray(forKey: "Tasks\(id)") ?? []
    }
    
    func saveTasks() {
        UserDefaults.standard.set(tasks, forKey: "Tasks\(id)")
    }
}
