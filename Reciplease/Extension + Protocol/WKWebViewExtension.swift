//
//  WKWebViewExtension.swift
//  Reciplease
//
//  Created by Alexandre Goncalves on 11/02/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
