//
//  SettingsViewController.swift
//  Bundle.Sandbox.FileManager
//
//  Created by Тарас Андреев on 19.06.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var changePassword: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить пароль", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.addTarget(self, action: #selector(changePasswordButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var installButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить изменения", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.addTarget(self, action: #selector(actionInstallButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
        setupSettings()
    }
    
    private lazy var sortedSettingsView: SettingView = {
        let settingsView = SettingView(text: "Сортировка по алфавиту", items: ["Вкл", "Выкл"])
        settingsView.segmentedControl.selectedSegmentIndex = 0
        return settingsView
    }()
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupSubviews() {
        view.addSubview(settingsLabel)
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(sortedSettingsView)
        sortedSettingsView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(22)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(changePassword)
        changePassword.snp.makeConstraints { make in
            make.top.equalTo(sortedSettingsView.snp.bottom).offset(16)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(installButton)
        installButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
            make.width.equalTo(220)
        }
    }
    
    private func setupSettings() {
        let isDescending = UserDefaults.standard.bool(forKey: "List.descending")
        sortedSettingsView.segmentedControl.selectedSegmentIndex = isDescending ? 1 : 0
        sortedSettingsView.changeHandler = { index in
            UserDefaults.standard.set(index != 0, forKey: "List.descending")
        }
    }
    
    @objc private func actionInstallButton() {
        tabBarController?.selectedIndex = 0
    }
    
    @objc private func changePasswordButton() {
        let passwordVC = PasswordViewController(mode: .change)
        navigationController?.present(passwordVC, animated: true, completion: nil)
    }
}
