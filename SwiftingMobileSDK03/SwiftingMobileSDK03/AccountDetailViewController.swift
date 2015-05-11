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
    var account : [NSObject:AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAccountData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadAccountData() {
        if self.account != nil {
            self.name.text = self.account?["Name"] as? String
            self.postalCode.text = self.account?["BillingPostalCode"] as? String
            var state = self.account?["BillingState"] as? String
            var city = self.account?["BillingCity"] as? String
            var street = self.account?["BillingStreet"] as? String
            self.address.text = "\(state) \(city) \(street)"
        }
    }
    
    func refresh() {
        if self.account == nil { return }
        
        SFRestAPI.sharedInstance().performRetrieveWithObjectType("Account",
            objectId: self.account!["Id"] as! String,
            fieldList: ["Id", "Name", "BillingPostalCode", "BillingState", "BillingCity", "BillingStreet"],
            failBlock: { ( error : NSError!) in
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
            completeBlock: {( response : [NSObject:AnyObject]!) in
                self.account = response as? [NSString:AnyObject]
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadAccountData()
                })
            }
        )
    }

    @IBAction func confirmAction(sender: AnyObject) {

        let actionSheet = UIAlertController(
            title: "アクション選択",
            message: "下記から選択ください。",
            preferredStyle: .ActionSheet
        )
        let okAction = UIAlertAction(
            title: "編集",
            style: .Default,
            handler: {( action : UIAlertAction!) in
                if let editVc = self.storyboard?.instantiateViewControllerWithIdentifier("account_edit") as? AccountEditViewController {
                    actionSheet.dismissViewControllerAnimated(true, completion: nil)
                    editVc.account = self.account
                    self.navigationController!.pushViewController(editVc, animated: true)
                }
            }
        )
        let cancelAction = UIAlertAction(
            title: "キャンセル",
            style: .Cancel,
            handler: {( action : UIAlertAction! ) in
                actionSheet.dismissViewControllerAnimated(true, completion: nil);
            }
        )
        actionSheet.addAction(okAction)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }

}
