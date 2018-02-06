//
//  SettingController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import TOPasscodeViewController

enum SecurityPinSettingType: String {
    case set = "Set"
    case confirm = "Confirm"
    case cancel = "Enter"
}

class SettingController: UIViewController {
    
    let cellId = "cellId"
    
    var securityPinSettingType: SecurityPinSettingType = .set
    
    let editProfileCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    
    let nightModeCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    let securityPinCell: UITableViewCell = {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }()
    
    let editProfileLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: 200, height: 40)
        label.text = "Edit Profile"
        label.textColor = DarkModeManager.getDefaultTextColor()
        return label
    }()
    
    var nightModeLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: 200, height: 40)
        label.text = "Night Mode"
        label.textColor = DarkModeManager.getDefaultTextColor()
        return label
    }()
    
    var nightModeSwitch: UISwitch = {
        let nightModeSwitch = UISwitch(frame: CGRect(x: DEVICE_WIDTH - 70, y: 10, width: 50, height: 40))
        nightModeSwitch.onTintColor = StyleGuideManager.realyfeDefaultGreenColor
        nightModeSwitch.addTarget(self, action: #selector(handleDarkModePinSwitch(sender:)), for: .valueChanged)
        nightModeSwitch.isOn = isDarkMode() ? true : false
        return nightModeSwitch
    }()
    lazy var securityPinSwitch: UISwitch = {
        let pinSwitch = UISwitch(frame: CGRect(x: DEVICE_WIDTH - 70, y: 10, width: 50, height: 40))
        pinSwitch.onTintColor = StyleGuideManager.realyfeDefaultGreenColor
        pinSwitch.addTarget(self, action: #selector(handleSecurityPinSwitch(sender:)), for: .valueChanged)
        pinSwitch.isOn = isSecurity() ? true : false
        return pinSwitch
    }()
    
    var securityPinLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 10, width: 200, height: 40)
        label.text = "Security Pin"
        label.textColor = DarkModeManager.getDefaultTextColor()
        return label
    }()
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        self.securityPinSettingType = isSecurity() ? .cancel : .set
    }
}

extension SettingController {
    
    @objc fileprivate func handleDarkModePinSwitch(sender: UISwitch) {
        
        let isDarkMode = sender.isOn
        
        UserDefaults.standard.setDarkMode(isDarkMode)
        
        resetBackground()
    }
    
    private func resetBackground() {
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        editProfileLabel.textColor = DarkModeManager.getDefaultTextColor()
        securityPinLabel.textColor = DarkModeManager.getDefaultTextColor()
        nightModeLabel.textColor = DarkModeManager.getDefaultTextColor()
        tableView.reloadData()
        
        navigationController?.navigationBar.barTintColor = DarkModeManager.getNavBarTintColor()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .resetNavBarTintColor, object: nil)
        notificationCenter.post(name: .resetSideMenuBackground, object: nil)
    }
}

extension SettingController {
    
    @objc fileprivate func handleSecurityPinSwitch(sender: UISwitch) {
        
        self.presentPassCodeController()
        
    }
    
    @objc fileprivate func presentPassCodeController() {
        
        var passcodeController: TOPasscodeViewController
        if isDarkMode() {
            passcodeController = TOPasscodeViewController(style: .translucentDark, passcodeType: .fourDigits, titleName: "\(self.securityPinSettingType.rawValue) Security Pin")
        } else {
            passcodeController = TOPasscodeViewController(style: .translucentLight, passcodeType: .fourDigits, titleName: "\(self.securityPinSettingType.rawValue) Security Pin")
        }
        passcodeController.delegate = self
        self.present(passcodeController, animated: true, completion: nil)
    }
    
    fileprivate func isSecurity() -> Bool {
        
        return UserDefaults.standard.isSecuirty()
    }
}

//MARK: handle passcode controller delegate
extension SettingController: TOPasscodeViewControllerDelegate {
    
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        
        let userDefaults = UserDefaults.standard
        
        if self.securityPinSettingType == .set {
            
            userDefaults.setSecurityCode(code)
            
            self.securityPinSettingType = .confirm
            self.perform(#selector(presentPassCodeController), with: nil, afterDelay: 0.5)
            return true
            
        } else if securityPinSettingType == .confirm {
            
            if code == userDefaults.getSecurityCode() {
                self.securityPinSettingType = .cancel
                userDefaults.setSecuirty(value: true)
                return true
            } else {
                return false
            }
            
        } else {
            
            if code == userDefaults.getSecurityCode() {
                self.securityPinSettingType = .set
                userDefaults.setSecuirty(value: false)
                return true
            } else {
                return false
            }
        }
    }
    
    func didTapCancel(in passcodeViewController: TOPasscodeViewController) {
        passcodeViewController.dismiss(animated: true) {
            
            if self.securityPinSettingType == .cancel {
                self.securityPinSwitch.isOn = true
            } else {
                self.securityPinSettingType = .set
                self.securityPinSwitch.isOn = false
            }
        }
    }
    
}

extension SettingController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return self.editProfileCell
        } else {
            if indexPath.row == 0 {
                return self.nightModeCell
            } else {
                return self.securityPinCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let editProfileController = EditProfileController()
            let navConroller = UINavigationController(rootViewController: editProfileController)
            self.present(navConroller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = DarkModeManager.getTableViewHeaderBackgroundColor()
        return view
    }
}

extension SettingController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        setupCells()
        setupTableView()
    }
    
    private func setupCells() {
        
        
        editProfileCell.addSubview(editProfileLabel)
        nightModeCell.addSubview(nightModeLabel)
        
        nightModeCell.addSubview(nightModeSwitch)
        
        securityPinCell.addSubview(securityPinLabel)
        
        securityPinCell.addSubview(securityPinSwitch)
        
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        _ = tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
}
















