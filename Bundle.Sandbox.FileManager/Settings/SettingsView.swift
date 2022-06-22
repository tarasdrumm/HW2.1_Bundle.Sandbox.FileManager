//
//  SettingsView.swift
//  Bundle.Sandbox.FileManager
//
//  Created by Тарас Андреев on 19.06.2022.
//

import UIKit
import SnapKit

class SettingView: UIView {

    var changeHandler: ((Int) -> Void)?
    
    private (set) lazy var label: UILabel = {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        
        return label
    }()
    
    private(set) lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: items)
        control.addTarget(self, action: #selector(change), for: .valueChanged)
        control.layer.cornerRadius = 10
        control.layer.masksToBounds = true
        control.backgroundColor = .white
        control.selectedSegmentTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        return control
    }()

    private let text: String
    private let items: [String]
    
    init(text: String, items: [String]) {
        self.text = text
        self.items = items
        super.init(frame: .zero)
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func change() {
        changeHandler?(segmentedControl.selectedSegmentIndex)
    }
}
