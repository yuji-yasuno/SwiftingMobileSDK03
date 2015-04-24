//
//  AccountDetailViewController.swift
//  SwiftingMobileSDK03
//
//  Created by 楊野 勇智 on 2015/04/24.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

class AccountDetailViewController: UITableViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var address: UILabel!
    var account : [String:AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.account != nil {
            self.name.text = self.account?["Name"] as? String
            self.postalCode.text = self.account?["BillingPostalCode"] as? String
            var state = self.account?["BillingState"] as? String
            var city = self.account?["BillingCity"] as? String
            var street = self.account?["BillingStreet"] as? String
            self.address.text = "\(state) \(city) \(street)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
