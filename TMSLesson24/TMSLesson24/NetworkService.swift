//
//  NetworkService.swift
//  lesson24project
//
//  Created by Карина Дьячина on 22.02.24.
//

import Foundation

class NetworkService {
    static func fetchCityDetails(for cityName: String, completion: @escaping (ResultModel?, Error?) -> Void) {
        let urlString =  "\(ViewController.Constants.baseURL)/geocode/v1/json?q=\(cityName)&key=\(ViewController.Constants.apiKey)"
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ResultModel.self, from: data)
                        completion(result, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
            
            task.resume()
        } else {
            let error = NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка в создании URL"])
            completion(nil, error)
        }
    }
}
