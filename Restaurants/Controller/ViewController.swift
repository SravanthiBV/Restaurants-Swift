//
//  ViewController.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/18/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit

enum TableCell :String{
    case cellId = "ItemDetailsCell"
}

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    let dataManager = RestaurantManager(withDataSource: RestaurantDataSource())
    var restaurantItems : [RestaurantItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setUpViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpViewController(){
        self.title = "Restaurants"
        loadTable()
        createRefreshControl()
    }
    
    func createRefreshControl(){
        self.restaurantsTableView.refreshControl = UIRefreshControl()
        self.restaurantsTableView.refreshControl?.tintColor = UIColor.white
        self.restaurantsTableView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: UIControl.Event.valueChanged)
        activityIndicator.startAnimating()
    }
    
    @objc func refreshControlAction(){
        self.restaurantsTableView.reloadData()
        perform(#selector(dismissRefreshControl), with: nil, afterDelay: 1)
    }
    
    @objc func dismissRefreshControl(){
        self.restaurantsTableView.refreshControl?.endRefreshing()
    }
    
    func loadTable() {
        dataManager.getRestaurantIems()  {
            [weak self] (restaurantData) in
            print("Got my callback in loadTable()")
            self?.restaurantItems = restaurantData
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.hidesWhenStopped = true
                self?.restaurantsTableView.reloadData()
            }
        }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.restaurantItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.cellId.rawValue)
        if let restaurant :RestaurantItem = restaurantItems?[indexPath.row]{
            cell?.textLabel?.text = restaurant.name
            cell?.textLabel?.textColor = UIColor.white
            let selectedView = UIView()
            selectedView.backgroundColor = UIColor(red: 57/255, green: 150/255, blue: 250/255, alpha: 1)
            cell?.selectedBackgroundView = selectedView
            if let imageData = restaurant.imageData{
                print("Restuaurant name is \(imageData)")
                cell?.imageView?.image = UIImage(data: imageData)
            }
            else{
                let defaultImage = UIImage(named:"restaurant.png")
                cell?.imageView?.image = defaultImage
            }
        }
        
        cell?.detailTextLabel?.text = "Detail"
        return cell!
    }
    
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailControllerId") as! DetailsViewController
        dismissRefreshControl()
        detailViewController.restaurantItemDetals = restaurantItems?[indexPath.row] ?? nil
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView .deselectRow(at: indexPath, animated: false)
    }
}

