//
//  DetailViewController.swift
//  BookFinderWithCodableEx
//
//  Created by j2mni on 2022/10/24.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {
    var strURL:String?
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let strURL = self.strURL,
              let url = URL(string: strURL) else { return }
        // URL -> URLRequest -> webview.load(request)
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
