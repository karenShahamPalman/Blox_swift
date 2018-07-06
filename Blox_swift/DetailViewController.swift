//
//  DetailViewController.swift
//  Blox_swift
//
//  Created by Karen Shaham on 06/07/2018.
//  Copyright © 2018 Karen Shaham. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var symbol: UIImageView!
    @IBOutlet weak var change_1h: UILabel!
    @IBOutlet weak var change_24h: UILabel!
    @IBOutlet weak var change_7d: UILabel!
    var service : WebCurrencyService!
    let percentText = "Percent Change in the last "

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            self.title = detail.name
            
            service = WebCurrencyService()
            service.getDetails(index: detail.id) { (response) in
                let dict = response["data"]! as! NSDictionary
                let quotes = dict["quotes"]! as! NSDictionary
                let EUR = quotes["EUR"]! as! NSDictionary
                
                DispatchQueue.main.async {
                    if let price = EUR["price"]! as? Double {
                        self.price.text = "Price: " + String(format:"%f", price) + " EUR"
                    }
                    if let percent_change_1h = EUR["percent_change_1h"]! as? Double {
                        self.change_1h.text = self.percentText + "hour: " + String(percent_change_1h)
                    }
                    if let percent_change_24h = EUR["percent_change_24h"]! as? Double {
                        self.change_24h.text = self.percentText + "24 hours: " + String(percent_change_24h)
                    }
                    if let percent_change_7d = EUR["percent_change_7d"]! as? Double {
                        self.change_7d.text = self.percentText + "7 days: " + String(percent_change_7d)
                    }
                    
                    do {
                        let imagePath = "https://s2.coinmarketcap.com/static/img/coins/64x64/" + String(detail.id) + ".png"
                        let url : URL = URL(string:imagePath)!
                        let imageData = try Data(contentsOf: url)
                        self.symbol.image = UIImage(data: imageData)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Coin? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

