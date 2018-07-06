//
//  WebCurrencyService.swift
//  Blox_swift
//
//  Created by Karen Shaham on 06/07/2018.
//  Copyright © 2018 Karen Shaham. All rights reserved.
//

import Foundation

class WebCurrencyService {

    let urlCoins = "https://api.coinmarketcap.com/v2/ticker/"
    let sort = "?sort=name"
    let detailsEUR = "/?convert=EUR"

    // get the top 100 cryptocurrency
    func getCoins(callback:@escaping (NSDictionary) -> ()) {
        request(url: urlCoins + sort, callback: callback)
    }
    
    // get the specific crypto coin
    func getDetails(index: Int, callback:@escaping (NSDictionary) -> ()) {
        request(url: urlCoins + String(index) + detailsEUR, callback: callback)
    }

    func request(url:String, callback:@escaping (NSDictionary) -> ()) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do {
                let response = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                callback(response)
            } catch let err as NSError {
                print(err)
            }
        }
        task.resume()
    }
}
