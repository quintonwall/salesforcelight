//
//  LoginManager.swift
//  SalesforceLight
//
//  Created by QUINTON WALL on 10/21/15.
//  Copyright © 2015 QUINTON WALL. All rights reserved.
//

import Foundation
import OAuthSwift
import Alamofire

class LoginManager : NSObject {
    
    static let sharedInstance = LoginManager()
    var alamoFireInstance : Alamofire.Manager?
    
    private override init() {}
    
    
    internal func performLogin(key : String, secret : String, success: (manager : Alamofire.Manager) -> Void, failure: (result : String) -> Void) {
        let oauthswift = OAuth2Swift(
            consumerKey:    key,
            consumerSecret: secret,
            authorizeUrl:   "https://login.salesforce.com/services/oauth2/authorize",
            accessTokenUrl: "https://login.salesforce.com/services/oauth2/token",
            responseType:   "code"
        )
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/salesforce")!, scope: "full", state: state, success: {
            credential, response, parameters in
           print("Successfully logged into Salesforce oauth_token:\(credential.oauth_token)")
            
            
            var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
            defaultHeaders["Authorization"] = "Bearer "+credential.oauth_token.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            defaultHeaders["x-li-format"] =  "json"
            defaultHeaders["Content-Type"] = "application/json"
            
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            configuration.HTTPAdditionalHeaders = defaultHeaders
            
            self.alamoFireInstance = Alamofire.Manager(configuration: configuration)
            success(manager: self.alamoFireInstance!)

            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
                failure(result: "Login failed with error: "+error.localizedDescription)
       
        })
    }
    
}
