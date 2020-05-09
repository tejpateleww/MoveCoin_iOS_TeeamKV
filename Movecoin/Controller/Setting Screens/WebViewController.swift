//
//  WebViewController.swift
//  Movecoins
//
//  Created by eww090 on 30/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var viewParent: UIView!
    var webView: WKWebView?
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var documentType : DocumentType!
    
    // ----------------------------------------------------
    // MARK: - --------- ViewController Lifecycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        localizeUI(parentView: self.viewParent)
        self.initialSetup()
        webserviceforPolicyHelpTerm()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView?.frame = CGRect(x: 0, y: 0, width: viewParent.frame.width, height: viewParent.frame.height)//viewParent.frame
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarSetUp(title: documentType.rawValue)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func initialSetup(){
        self.view.backgroundColor = ThemeNavigationColor
        webView = WKWebView()
        webView?.backgroundColor = .clear
        viewParent.addSubview(webView ?? WKWebView())
        webView?.navigationDelegate = self
        webView?.backgroundColor = ThemeNavigationColor
        webView?.allowsBackForwardNavigationGestures = true
    }
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UtilityClass.showHUD()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UtilityClass.hideHUD()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UtilityClass.hideHUD()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UtilityClass.hideHUD()
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension WebViewController {
    
    func webserviceforPolicyHelpTerm(){
        
        UtilityClass.showHUD()
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.policyHelpTerm.rawValue
        
        UserWebserviceSubclass.getAPI(strURL: strParam) { (json, status, res) in
            print(status)
            
            UtilityClass.hideHUD()
            
            let responseModel = PolicyHelpTermsClass(fromJson: json)
            
            switch self.documentType {
            case .TermsAndCondition:
                self.load(responseModel.termsLink)
                
            case .PrivacyPolicy:
                self.load(responseModel.policyLink)
                
            case .Help:
                self.load(responseModel.helpLink)
                
            case .none:
                return
            }
        }
    }
}
