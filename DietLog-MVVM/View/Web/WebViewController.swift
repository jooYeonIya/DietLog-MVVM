//
//  WebViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.allowsBackForwardNavigationGestures = true
        return view
    }()
    
    private lazy var refreshButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: nil, action: nil)
        button.tintColor = .black
        return button
    }()
    
    private lazy var webViewToolbar = WebViewToolBar()

    // MARK: - 변수
    private let youtubeURL: String?
       
    // MARK: - 초기화
    init(youtubeURL: String) {
        self.youtubeURL = youtubeURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        
        if let youtubeURL = URL(string: youtubeURL ?? "https://www.youtube.com/") {
            let request = URLRequest(url: youtubeURL)
            webView.load(request)
        }
    }
    
    // MARK: - setup UI
    override func setupUI() {
        view.addSubviews([activityIndicator, webView, webViewToolbar])
    }
    
    // MARK: - setup Layout
    override func setupLayout() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(webViewToolbar.snp.top)
        }
        
        webViewToolbar.snp.makeConstraints { constraint in
            constraint.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - setup Delegate
    override func setupDelegate() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    // MARK: - setup Event
    override func setupEvent() {
        refreshButton.target = self
        refreshButton.action = #selector(didTappedRefreshButton(_:))
        
        webViewToolbar.backwardButton.target = self
        webViewToolbar.backwardButton.action = #selector(didTappedBackwardButton(_:))

        webViewToolbar.forwardButton.target = self
        webViewToolbar.forwardButton.action = #selector(didTappedForwardButton(_:))

        webViewToolbar.shareButton.target = self
        webViewToolbar.shareButton.action = #selector(didTappedShareButton(_:))

        webViewToolbar.safariButton.target = self
        webViewToolbar.safariButton.action = #selector(didTappedSafariButton(_:))
    }
    
    // MARK: - setup NavigationBar
    override func setupNavigationBar() {
        navigationItem.rightBarButtonItem = refreshButton
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        showAlertWithOKButton(title: "", message: message, completion: {
            completionHandler()
        })
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        showAlertTwoButton(title: "", message: message, actionCompletion: {
            completionHandler(true)
        }, cancelCompletion: {
            completionHandler(false)
        })
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
            completionHandler(nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}

// MARK: - @objc 메소드
extension WebViewController {
    
    // NavgationBar
    @objc func didTappedRefreshButton(_ buttonItem: UIBarButtonItem) {
       webView.reload()
    }

    // ToolBar
    @objc func didTappedBackwardButton(_ buttonItem: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func didTappedForwardButton(_ buttonItem: UITabBarItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    @objc func didTappedShareButton(_ buttonItem: UITabBarItem) {
        guard let url = webView.url else { return }
        let viewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(viewController, animated: true)
    }
    
    @objc func didTappedSafariButton(_ buttonItem: UITabBarItem) {
        guard let url = webView.url else { return }
        UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
