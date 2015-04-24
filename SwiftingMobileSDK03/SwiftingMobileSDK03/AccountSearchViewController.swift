//
//  AccountSearchViewController.swift
//  SwiftingMobileSDK03
//
//  Created by 楊野 勇智 on 2015/04/24.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

class AccountSearchViewController: UITableViewController, UISearchBarDelegate {
    
    
    var accounts : [AnyObject]?
    @IBOutlet weak var name: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show_detail" {
            var detailVC = segue.destinationViewController as! AccountDetailViewController
            var indexPath = self.tableView.indexPathForSelectedRow()
            detailVC.account = self.accounts?[indexPath!.row] as? [String:AnyObject]
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts != nil ? self.accounts!.count : 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("account_cell", forIndexPath: indexPath) as! UITableViewCell
        var account = self.accounts![indexPath.row] as! [String:AnyObject]
        cell.textLabel?.text = account["Name"] as? String
        return cell
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText.utf16) > 0 {
            self.searchAccounts(searchText)
        }
    }
    
    func searchAccounts(partOfName: String) {
        
        let soql = "SELECT Id,Name,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE Name LIKE '%\(partOfName)%'"
        println(soql);
        SFRestAPI.sharedInstance().performSOQLQuery(soql,
            failBlock: {(error : NSError!) in
                var alert = UIAlertController(title: "エラー", message: error.localizedDescription, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action : UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            },
            completeBlock: {(responseData : [NSObject:AnyObject]!) in
                self.accounts = responseData["records"] as? Array<AnyObject>
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        )
        
    }

}
