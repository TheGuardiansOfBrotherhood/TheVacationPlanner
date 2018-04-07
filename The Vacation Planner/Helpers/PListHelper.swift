//
//  PListHelper.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 07/04/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

class PListHelper {

    func getInfo(key: String) -> String {
        let file = Bundle.main.path(forResource: "URLs", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        return dictionary[key] as! String
    }

}
