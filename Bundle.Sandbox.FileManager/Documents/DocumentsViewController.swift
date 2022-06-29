//
//  DocumentsViewController.swift
//  Bundle.Sandbox.FileManager
//
//  Created by Тарас Андреев on 13.06.2022.
//

import UIKit
import SnapKit

class DocumentsViewController: UIViewController {
    
    private var rootDirectory: URL?
    private var directory: URL?
    private var contentOfDirectory: [String]?
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Documents"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .darkGray
        return titleLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }()
        
    private lazy var addPhotosButton: UIBarButtonItem = {
        let photoBarButton = UIImage(systemName: "photo.on.rectangle")
        return UIBarButtonItem(image: photoBarButton, style: .done, target: self, action: #selector(photoButton))
    }()
    
    private lazy var addFolderButton: UIBarButtonItem = {
        let folderBarButton = UIImage(systemName: "plus.rectangle.on.folder")
        return UIBarButtonItem(image: folderBarButton, style: .done, target: self, action: #selector(folderButton))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [addPhotosButton, addFolderButton]
    }
    
    private func setupSubviews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти из папки", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(backToDocuments), for: .touchUpInside)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let rootDirectory = rootDirectory {
            updateDirectory(rootDirectory)
        }
        tableView.reloadData()
    }
    
    init() {
        rootDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        super.init(nibName: nil, bundle: nil)
        guard let rootDirectory = rootDirectory else { return }
        updateDirectory(rootDirectory)
        directory = rootDirectory
    }
    
    @objc private func folderButton(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Создать папку", message: "Введите имя папки", preferredStyle: .alert)
        alert.addTextField() { name in
            name.textColor = .black
            name.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            name.autocapitalizationType = .none
            name.placeholder = "Имя папки"
        }
        let okAction = UIAlertAction(title: "Создать", style: .default) { [self] _ in
            guard let text = alert.textFields?[0].text else { return }
            createFolder(text)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func photoButton(sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func backToDocuments() {
        if let rootDirectory = rootDirectory {
            updateDirectory(rootDirectory)
        }
        tableView.reloadData()
    }
    
    private func updateDirectory(_ name: URL) {
        let content = try? FileManager.default.contentsOfDirectory(at: name, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).map(){ $0.lastPathComponent }
        guard let content = content else { return }
        contentOfDirectory = content
        contentOfDirectory?.sort(by: { lhs, rhs in
            if UserDefaults.standard.bool(forKey: "List.descending") {
                return lhs > rhs
            }
            else {
                return lhs < rhs
            }
        })
        directory = name
    }

    private func createFolder(_ name: String) {
        guard let directory = directory else { return }
        let newDirectory = directory.appendingPathComponent(name, isDirectory: true)
        try? FileManager.default.createDirectory(atPath: newDirectory.path, withIntermediateDirectories: true, attributes: nil)
        updateDirectory(directory)
        tableView.reloadData()
    }
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let directory = directory else { return nil }
        return "\(directory.lastPathComponent)/"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = contentOfDirectory?.count else { return 0 }
        return count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            guard let name = contentOfDirectory?[indexPath.item] else { return UITableViewCell(style: .default, reuseIdentifier: "cell")}
            cell.textLabel?.text = name
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard var directory = directory else { return }
            guard let cellText = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
            directory = directory.appendingPathComponent(cellText)
            if (try? directory.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false {
                updateDirectory(directory)
                tableView.reloadData()
        }
    }
}

extension DocumentsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            dismiss(animated: true, completion: nil)
            return
        }
        let saveImage = image.jpegData(compressionQuality: 1)
        guard let imageUrl = directory?.appendingPathComponent(imageURL.lastPathComponent) else {
            dismiss(animated: true, completion: nil)
            return
        }
        if FileManager.default.fileExists(atPath: imageUrl.path) {
            dismiss(animated: true, completion: nil)
            let alertPicture = UIAlertController(title: "Попробуйте снова", message: "картинка уже существует", preferredStyle: .alert)
            present(alertPicture, animated: true){ [self] in
                sleep(3)
                dismiss(animated: true, completion: nil)
            }
        } else {
            try? saveImage?.write(to: imageUrl)
            if let directory = directory {
                updateDirectory(directory)
            }
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
