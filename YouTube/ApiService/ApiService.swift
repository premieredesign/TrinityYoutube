//
//  ApiService.swift
//  YouTube
//
//  Created by Clinton Johnson on 10/10/17.
//  Copyright © 2017 Clinton Johnson. All rights reserved.
//

import Foundation


class APIService {
    static let shared = APIService()
    
    func fetchSongs<T:Decodable>(month: String, completion: @escaping (T) -> ()) {
        guard let url = URL(string: "https://s3.us-east-2.amazonaws.com/tcc-data/Trinity/2018/Month/\(month)/API.json") else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err {
                print("Failed to retrieve data", err.localizedDescription)
                return
            }
            
            guard let data = data else {return}
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(obj)
                }
            } catch let decodeErr {
                print("Failed to decode", decodeErr.localizedDescription)
            }
        }.resume()
    }
}

