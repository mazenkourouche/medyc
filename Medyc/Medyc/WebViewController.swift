//
//  WebViewController.swift
//  Medyc
//
//  Created by Mazen Kourouche on 4/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var wkWebView: WKWebView!
    
    @IBOutlet weak var guideView: UIView!
    var receivedURL:String!
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wkWebView = WKWebView()
        wkWebView.alpha = 0
        
        wkWebView.navigationDelegate = self
        activityIndicator.activityIndicatorViewStyle = .gray
        let barIndicator = UIBarButtonItem(customView: activityIndicator)
        
        searchBar.text = self.receivedURL
        searchBar.isUserInteractionEnabled = false
        searchBar.barStyle = .default
        searchBar.setImage(UIImage(), for: UISearchBarIcon.clear, state: UIControlState.normal)
        
        searchBar.endEditing(true)
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        leftNavBarButton.isEnabled = false
        //self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        self.navigationItem.rightBarButtonItems = [barIndicator,leftNavBarButton]
        self.view.addSubview(wkWebView)
        self.view.bringSubview(toFront: wkWebView)
        loadWebpage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        wkWebView.frame = self.guideView.frame
        
        UIView.animate(withDuration: 0.2) {
            self.wkWebView.alpha = 1
        }
    }

    func loadWebpage () {
        if let url = URL(string: receivedURL) {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
