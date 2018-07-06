//
//  Coin.swift
//  Blox_swift
//
//  Created by Karen Shaham on 06/07/2018.
//  Copyright © 2018 Karen Shaham. All rights reserved.
//

import Foundation

class Coin {
    var id : Int
    var name : String
    var symbol : String
    var website_slug : String
    var price: Double
    var imagePath : String
    
    init(id : Int, name : String, symbol : String, website_slug : String, price: Double) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.website_slug = website_slug
        self.price = price
        self.imagePath = "https://s2.coinmarketcap.com/static/img/coins/16x16/" + String(id) + ".png"
    }
}
