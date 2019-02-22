//
//  DetailsViewController.swift
//  Restaurants
//
//  Created by Sravanthi BV on 2/18/19.
//  Copyright © 2019 Sravanthi BV. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var restaurantItemDetals : RestaurantItem?
   
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDetailsController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpDetailsController(){
        if let imageData = restaurantItemDetals?.imageData{
            imageView.image = UIImage(data: imageData)
            print("imageView is \(imageView!)")
        }
        nameLabel.text = restaurantItemDetals?.name
        addressLabel.text = restaurantItemDetals?.address
        zipCodeLabel.text = restaurantItemDetals?.pincode
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
