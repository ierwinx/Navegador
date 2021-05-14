import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButtom: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    
    private let searchBar = UISearchBar()
    private let recargarPagina = UIRefreshControl()
    
    private let baseURL: String = "https://www.google.com"
    private let searchPath: String = "/search?q="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isEnabled = false
        forwardButtom.isEnabled = false
        
        // WEB VIEW
        let preferencias = WKPreferences()
        preferencias.javaScriptEnabled = true
        preferencias.javaScriptCanOpenWindowsAutomatically = true
        
        let wevViewConf = WKWebViewConfiguration()
        wevViewConf.preferences = preferencias
        
        webView.navigationDelegate = self
        webView.scrollView.keyboardDismissMode = .onDrag // oculta el teclado cuando deslicemos hacia arriba o abajo
        recargarPagina.addTarget(self, action: #selector(recargar), for: .valueChanged)
        webView.scrollView.addSubview(recargarPagina)
        view.bringSubviewToFront(recargarPagina)
        cargarPagina(direccion: baseURL)
    }
    
    @IBAction func backAction(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func recargaAction(_ sender: Any) {
        recargar()
    }
    
    @IBAction func buscarAction(_ sender: Any) {
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func cargarPagina(direccion: String) {
        var urlACargar: URL!
        if let url = URL(string: direccion), UIApplication.shared.canOpenURL(url) {
            urlACargar = url
        } else {
            urlACargar = URL(string: "\(baseURL)\(searchPath)\(direccion)")
        }
        
        webView.load(URLRequest(url: urlACargar))
    }
    
    @objc private func recargar() {
        webView.reload()
    }
    
}

// DELEGADO Barra de Busqueda
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        cargarPagina(direccion: searchBar.text ?? "")
    }
}

// DELEGADO WEBVIEW
extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        recargarPagina.endRefreshing()
        backButton.isEnabled = webView.canGoBack
        forwardButtom.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        recargarPagina.beginRefreshing()
        searchBar.text = webView.url?.absoluteString
    }
    
}
