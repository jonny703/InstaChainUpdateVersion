//
//  AgreementController.swift
//  InstaChain
//
//  Created by John Nik on 2/5/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD

class AgreementController: UIViewController {
    
    var urlString: String?
    
    lazy var webView: UIWebView = {
        
        let webView = UIWebView()
        webView.backgroundColor = DarkModeManager.getViewBackgroundColor()
        webView.delegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        handleLoadWebView()
    }
}

extension AgreementController {
    
    fileprivate func handleLoadWebView() {
        
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        SVProgressHUD.show()
    }
}

extension AgreementController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
        
        self.showJHTAlerttOkayWithIcon(message: "Something went wrong\nTry again later")
    }
}

extension AgreementController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        setupWebView()
    }
    
    private func setupWebView() {
        
        view.addSubview(webView)
        _ = webView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
