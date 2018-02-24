//
//  UrlHelper.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

class UrlHelper  {
    
    func startLoad() {
        let url = URL(string: "http://localhost:8882/cities/")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
//                self.handleClientError(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
//                    self.handleServerError(response)
                    return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(string)
//                    self.webView.loadHTMLString(string, baseURL: url)
                }
            }
        }
        task.resume()
    }
    
}
