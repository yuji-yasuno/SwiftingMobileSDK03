//
//  AccountEditViewController.swift
//  SwiftingMobileSDK03
//
//  Created by 楊野 勇智 on 2015/05/11.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

class AccountEditViewController: UITableViewController {
    
    var account : [NSObject:AnyObject]?
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var billingState: UITextField!
    @IBOutlet weak var billingCity: UITextField!
    @IBOutlet weak var billingStreet: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.account != nil {
            self.name.text = self.account?["Name"] as? String
            self.postalCode.text = self.account?["BillingPostalCode"] as? String
            self.billingState.text = self.account?["BillingState"] as? String
            self.billingCity.text = self.account?["BillingCity"] as? String
            self.billingStreet.text = self.account?["BillingStreet"] as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func save(sender: AnyObject) {
        self.updateAccount()
    }

    private func updateAccount() {
        if self.account == nil { return }
        
        let fields = [ "Name": "\(self.name.text)", "BillingPostalCode": "\(self.postalCode.text)", "BillingState": "\(self.billingState.text)", "BillingCity": "\(self.billingCity.text)", "BillingStreet": "\(self.billingStreet.text)"]
        SFRestAPI.sharedInstance().performUpdateWithObjectType("Account",
            objectId: self.account!["Id"] as! String,
            fields: fields,
            failBlock: {( error : NSError! ) in
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(
                        title: "エラー",
                        message: error.localizedDescription,
                        preferredStyle: .Alert
                    )
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: { ( action : UIAlertAction! ) in
                            alert.dismissViewControllerAnimated(true, completion: nil)
                        }
                    )
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            },
            completeBlock: { ( response : [NSObject:AnyObject]! ) in
                dispatch_async(dispatch_get_main_queue(), {
                    if self.navigationController != nil {
                        let detailVC = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? AccountDetailViewController
                        detailVC?.refresh()
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            }
        )
    }

}
