//
//  ViewController.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startLoad() {
        let url = URL(string: "http://localhost:8882/cities/")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
//                self.handleClientError(error)
                print("error")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
//                    self.handleServerError(response)
                    print("http-error")
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

