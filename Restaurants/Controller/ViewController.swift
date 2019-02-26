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

let noNetWorkViewTag = 50234

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    let dataManager = RestaurantManager(withDataSource: RestaurantDataSource())
    var restaurantItems : [RestaurantItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setUpViewController()
        setNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setNotifications(){
        NotificationCenter.default.addObserver(self, selector:#selector(self.networkChangedNotification), name:NSNotification.Name(rawValue: networkChangedNotificationID)  , object: nil)
    }
    
    @objc func networkChangedNotification( ){
        showControllerUiBasedOnNetwork()
    }
    
    func showControllerUiBasedOnNetwork(){
        if NetworkReachabilityManager.sharedInstance.isNetworkReachable(){
            removeNoNetworkView()
            hideComponents(hide: false)
        }
        else {
            hideComponents(hide: true)
            createNoNetworkView()
        }
    }
    
    func setUpViewController(){
        self.title = "Restaurants"
        loadTable()
        createRefreshControl()
        showControllerUiBasedOnNetwork()
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
            [weak self]
            (restaurantData) in
            print("Got my callback in loadTable()")
            self?.restaurantItems = restaurantData
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.hidesWhenStopped = true
                self?.restaurantsTableView.reloadData()
            }
        }
    }
    
    func createNoNetworkView(){
        let messageView = self.view.viewWithTag(noNetWorkViewTag)
        var noNetworkView : UIView
        if messageView != nil {
            noNetworkView = messageView!
        }
        else {
            noNetworkView = UIView()
            noNetworkView.tag = noNetWorkViewTag
            noNetworkView.backgroundColor = UIColor.black
            self.view.addSubview(noNetworkView)
        }
        noNetworkView.frame = CGRect.init(x: self.restaurantsTableView.frame.origin.x, y: self.restaurantsTableView.frame.origin.y, width: self.restaurantsTableView.frame.size.width, height: self.restaurantsTableView.frame.size.height)
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "No network. Make sure that your device is connected to a Wi-Fi or cellular network."
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.white
        noNetworkView.addSubview(messageLabel)
        
        let horizontalPos = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.centerX , relatedBy:NSLayoutConstraint.Relation.equal , toItem: noNetworkView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0)
        
        let verticalPos = messageLabel.centerYAnchor.constraint(equalTo: noNetworkView.centerYAnchor)
        
        let leadingConstarint = messageLabel.leadingAnchor.constraint(equalTo: noNetworkView.leadingAnchor, constant: 20)
        
        let trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: noNetworkView.trailingAnchor, constant: -20)
        
        noNetworkView.addConstraints([horizontalPos])
        noNetworkView.addConstraints([verticalPos])
        noNetworkView.addConstraints([leadingConstarint])
        noNetworkView.addConstraints([trailingConstraint])
    }
    
    func removeNoNetworkView() {
        if let noNetworkView = self.view.viewWithTag(noNetWorkViewTag) {
            noNetworkView.removeFromSuperview()
        }
    }
    
    func hideComponents(hide:Bool){
        self.restaurantsTableView.isHidden = hide
    }
    
    func showNoNetworkAlert(){
        let alert = UIAlertController(title:"No network.", message: "Make sure that your device is connected to a Wi-Fi or cellular network.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
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

