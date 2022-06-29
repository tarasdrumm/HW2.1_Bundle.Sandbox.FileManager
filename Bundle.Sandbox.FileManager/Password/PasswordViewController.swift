//
//  PasswordViewCintroller.swift
//  Bundle.Sandbox.FileManager
//
//  Created by Тарас Андреев on 19.06.2022.
//

import UIKit
import SnapKit
import KeychainAccess

let keychain = Keychain(service: "Taras-Andreev.Bundle-Sandbox-FileManager")

class PasswordViewController: UIViewController {

    enum Mode {
        case basic
        case change
    }

    private let mode: Mode
    private lazy var hasPassword = keychain["password"] != nil
    private var firstPassword: String?
  
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .systemGray6
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 10
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 0.3
        field.placeholder = " Пароль"
        return field
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return button
    }()

    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        if hasPassword && mode == .basic {
            button.setTitle("Введите пароль", for: .normal)
        }
        else {
            button.setTitle("Создать пароль", for: .normal)
        }
        
        view.addSubview(textField)
        view.addSubview(button)

        textField.snp.makeConstraints { make in
            make.leading.trailing.centerY.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(textField.snp_bottomMargin).offset(16)
            make.height.equalTo(50)
        }
    }

    @objc private func tapButton() {
        guard let text = textField.text else {
            return
        }
        if hasPassword && mode == .basic {
            if text == keychain["password"] {
                navigationController?.pushViewController(TabBarController(), animated: true)
            }
            else {
                let alert = UIAlertController(title: "Ошибка", message: "Нeправильный пароль", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
        else {
            guard text.count >= 4 else {
                let alert = UIAlertController(title: "Ошибка", message: "Короткий пароль", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            if let firstPassword = firstPassword {
                if text == firstPassword {
                    keychain["password"] = text
                    dismiss(animated: true, completion: nil)
                    return
                }
                else {
                    let alert = UIAlertController(title: "Ошибка", message: "Пароль не совпадает", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    present(alert, animated: true)
                }
            }
            else {
                firstPassword = text
                textField.text = ""
                button.setTitle("Повторите пароль", for: .normal)
            }
        }
    }
}
