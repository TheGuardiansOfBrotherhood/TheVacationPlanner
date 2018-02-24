//
//  URLHelper.swift
//  The Vacation Planner
//
//  Created by Roger Silva on 24/02/2018.
//  Copyright © 2018 Infinity Technology. All rights reserved.
//

import Foundation

enum URLHelperError: Error {
    case RequestError
    case HttpStatusError
    case SerializationJsonError
}

class URLHelper {
    
    func startLoad<T>(_ type: T.Type, _ url: String, _ funcSucess: @escaping (T) -> Void,
                      _ funcError: @escaping (URLHelperError) -> Void) throws where T : Decodable {
        let url = URL(string: url)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                funcError(URLHelperError.RequestError)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    funcError(URLHelperError.HttpStatusError)
                    return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                let data = data {
                do {
                    let objects = try JSONDecoder().decode(type, from: data)
                    funcSucess(objects)
                } catch {
                    funcError(URLHelperError.SerializationJsonError)
                }
            }
        }
        task.resume()
    }
    
}
