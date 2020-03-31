//
//  ViewController.swift
//  kancolle
//
//  Created by Hirohito on 2020/03/21.
//  Copyright © 2020 Hirohito. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKUIDelegate,WKNavigationDelegate {

    @IBOutlet var containerView: UIView!
    var webView: WKWebView!
    
    func webViewSetup(){
        let controller = WKUserContentController()
        var viewport: String;
        if (self.view.bounds.size.height / self.view.bounds.size.width) < (720 / 1200) {
            viewport = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'height=720');document.getElementsByTagName('head')[0].appendChild(meta);"
        }
        else {
            viewport = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=1200');document.getElementsByTagName('head')[0].appendChild(meta);"
        }
        
        let viewportSctipt = WKUserScript(source: viewport, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        controller.addUserScript(viewportSctipt)
        
        var css = "document.getElementById('game_frame').style.position = 'fixed';"
        css += "document.getElementById('game_frame').style.left = '50%';"
        css += "document.getElementById('game_frame').style.top = '-16px';"
        css += "document.getElementById('game_frame').style.marginLeft = '-600px';"
        css += "document.getElementById('game_frame').style.zIndex = 1;"
        let cssScript = WKUserScript(source: css, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        controller.addUserScript(cssScript)
        
        let dispNone = "document.getElementsByClassName('area-pickupgame')[0].style.display = 'none';"
        let dispNoneScript = WKUserScript(source: dispNone, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        controller.addUserScript(dispNoneScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller

        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
    }
    
    override func loadView() {
        super.loadView()
        
        webViewSetup()
        containerView.addSubview(webView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "http://www.dmm.com/netgame/social/-/gadgets/=/app_id=854854/#area-game") {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    override func viewDidLayoutSubviews() {
         //WKWebView リサイズ
         self.webView.frame = CGRect(origin: CGPoint.zero, size: self.containerView.frame.size)
     }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var style = "document.getElementById('game_frame').style.height = '';"
        style += "document.getElementById('game_frame').height = 736;"
        webView.evaluateJavaScript(style)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        super.viewWillTransition(to: size, with: coordinator)
        //code to refresh the views
        self.webView.frame.size.height = 1
        self.webView.frame.size = self.webView.sizeThatFits(.zero)
        self.webView.sizeToFit()
    } 
//    画面の回転対応
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        coordinator.animate(alongsideTransition: { _ in
//            var js:String
//            if (self.view.bounds.size.height / self.view.bounds.size.width) < (720 / 1200) {
//                js = "document.querySelector('meta[name='viewport']').setAttribute('content', 'height=720');"
//
//            }
//            else {
//                js = "document.querySelector('meta[name='viewport']').setAttribute('content', 'width=1200');"
//            }
//            self.webView.evaluateJavaScript(js)
//
//        }, completion: nil)
//    }
    
}

