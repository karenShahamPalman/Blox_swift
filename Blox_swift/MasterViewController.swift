//
//  MasterViewController.swift
//  Blox_swift
//
//  Created by Karen Shaham on 06/07/2018.
//  Copyright © 2018 Karen Shaham. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var coinsObjects = [Any]()
    var service : WebCurrencyService!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        service = WebCurrencyService()
        service.getCoins { (response) in
            let dict = response["data"]! as! NSDictionary
            self.loadCoins(coinsKeys: dict.allKeys as NSArray, dictionary: dict)
        }
    }

    func loadCoins(coinsKeys : NSArray, dictionary: NSDictionary) {
        for i in 0 ..< coinsKeys.count {
            let coinDict : NSDictionary = dictionary.value(forKey: coinsKeys[i] as! String) as! NSDictionary
            let id = coinDict["id"]! as! Int
            let name = coinDict["name"]! as! String
            let symbol = coinDict["symbol"]! as! String
            let website_slug = coinDict["website_slug"]! as! String
            
            let quotes = coinDict["quotes"]! as! NSDictionary
            let USD = quotes["USD"]! as! NSDictionary
            let price = USD["price"]! as! Double
            
            let coinObj = Coin(id: id, name: name, symbol: symbol, website_slug: website_slug, price: price)
            coinsObjects.append(coinObj)
        }
            
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = coinsObjects[indexPath.row] as! Coin
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

        let coinObject = coinsObjects[indexPath.row] as! Coin
        cell.textLabel!.text = coinObject.name
        cell.detailTextLabel?.text = "Price: " + String(format:"%f", coinObject.price) + "$"
        
        do {
            let url : URL = URL(string:coinObject.imagePath)!
            let imageData = try Data(contentsOf: url)
            cell.imageView?.image = UIImage(data: imageData)
        } catch {
            print("Unable to load data: \(error)")
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coinsObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

