//
//  QRScanController.swift
//  InstaChain
//
//  Created by John Nik on 2/2/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import MTBBarcodeScanner

class QRScanController: UIViewController {
    
    var loginController: LoginController?
    var scanner: MTBBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = backButton
        
        scanner = MTBBarcodeScanner(previewView: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.scanner?.stopScanning()
        
        super.viewWillDisappear(animated)
    }
    
    private func handleCameraPermission() {
        
    }
    
    private func loadScanner() {
        MTBBarcodeScanner.requestCameraPermission { (success) in
            
            if success {
                
                do {
                    
                    try self.scanner?.startScanning(resultBlock: { (codes) in
                        if let codes = codes {
                            for code in codes {
                                
                                if let stringValue = code.stringValue {
                                    
                                    print("qr code is: ", stringValue)
                                    
                                    self.showJHTAlerttOkayActionWithIcon(message: "Your password is\n\(stringValue)", action: { (action) in
                                        self.loginController?.setPasswordByQRScan(password: stringValue)
                                        self.dismiss(animated: true, completion: nil)
                                    })
                                    
                                }
                            }
                        }
                    })
                    
                } catch {
                    print("Unable to start scanning")
                }
            } else {
                
                
                
                self.showJHTAlerttOkayWithIcon(message: "Scanning Unavailable\nThis app does not have permission to access the camera")
            }
            
        }
    }
    
    @objc private func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}
