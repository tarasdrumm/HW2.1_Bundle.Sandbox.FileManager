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

    lazy var hasPassword = keychain["password"] != nil
    var firstPassword: String?
  
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        if hasPassword {
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

    @objc func tapButton() {
        guard let text = textField.text else {
            return
        }
        if hasPassword {
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
                    navigationController?.pushViewController(TabBarController(), animated: true)
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
