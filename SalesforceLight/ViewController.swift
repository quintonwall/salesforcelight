//
//  ViewController.swift
//  SalesforceLight
//
//  Created by QUINTON WALL on 10/21/15.
//  Copyright © 2015 QUINTON WALL. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {

    @IBOutlet var loginButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTapped(sender: AnyObject) {
    
        LoginManager.sharedInstance.performLogin(Salesforce["consumerKey"]!,secret: Salesforce["consumerSecret"]!,
            success: { manager in
                print("success")
                self.performSegueWithIdentifier("loggedin", sender: nil)
                
            }, failure: { result in
                print(result)
        })
    }

}

