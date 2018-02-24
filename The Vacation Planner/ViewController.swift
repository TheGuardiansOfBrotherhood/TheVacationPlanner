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
        do {
            try URLHelper().startLoad([City].self, "http://localhost:8882/cities/", funcSucess, funcError)
        } catch {
            print("Error City not is Decodable")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func funcSucess(data: [City])  {
        print(data)
    }
    
    func funcError(error: URLHelperError)  {
        switch error {
        case URLHelperError.RequestError:
            print("Error requesting")
        case URLHelperError.HttpStatusError:
            print("Error HTTP Status")
        case URLHelperError.SerializationJsonError:
            print("Error serialization JSON")
        }
    }
    
}

