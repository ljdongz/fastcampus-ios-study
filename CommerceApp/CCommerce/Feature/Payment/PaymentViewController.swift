//
//  PaymentViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/23/24.
//

import UIKit
import WebKit

final class PaymentViewController: UIViewController {
    
    private var webView: WKWebView?
    private let getMessageScriptName = "receiveMessage"
    private let getPaymentCompleteScriptName = "paymentComplete"
    
    override func loadView() {
        let contentController = WKUserContentController()
        
        // web에서 receiveMessage란 이름으로 handler가 올 시 처리
        contentController.add(self, name: getMessageScriptName)
        // web에서 paymentComplete란 이름으로 handler가 올 시 처리
        contentController.add(self, name: getPaymentCompleteScriptName)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        
        webView = WKWebView(frame: .zero, configuration: config)
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView?.load(URLRequest(url: URL(string: "https://google.com")!))
    }
    
    private func loadWebView() {
        // 프로젝트 내부에 test.html의 파일 경로를 가져옴
        guard let htmlPath = Bundle.main.path(forResource: "test", ofType: "html") else { return }
        
        let url = URL(filePath: htmlPath)
        var request = URLRequest(url: url)
        
        // 헤더 설정
        request.addValue("customValue", forHTTPHeaderField: "Header-Name")
        
        webView?.load(request)
    }

    // UserAgent 설정
    private func setUserAgent() {
        webView?.customUserAgent = "Cproject/1.0.0/iOS/"
    }
    
    // 쿠키 설정
    private func setCookie() {
        guard let cookie = HTTPCookie(properties: [
            .domain: "google.com",
            .path: "/",
            .name: "myCookie",
            .value: "value",
            .secure: "FALSE",
            .expires: NSDate(timeIntervalSinceNow: 3600) // 1시간 뒤에 만료
        ])
        else { return }
        
        webView?.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
    }
    
    // 자바스크립트 함수 호출
    private func callJavaScript() {
        // javascriptFunction();으로 정의되어있는 함수 호출
        webView?.evaluateJavaScript("javascriptFunction();")
    }
}

extension PaymentViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == getMessageScriptName {
            print(message.body)
        } else if message.name == getPaymentCompleteScriptName {
            print(message.body)
        }
    }
    
    
}


