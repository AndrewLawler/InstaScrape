//
//  ViewController.swift
//  WebScraper
//
//  Created by Andrew Lawler on 06/11/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//

import UIKit
import Foundation

var JSONData = ""
var scrapedData:[String:String] = [:]

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBOutlet var inputProfile: UITextField!
    @IBOutlet var jsonLabel: UILabel!
    @IBOutlet var dictionaryLabel: UILabel!
    
    func setup(){
        jsonLabel.numberOfLines = 0
        dictionaryLabel.numberOfLines = 0
    }
    
    @IBAction func scraping(_ sender: UIButton){
        
        let instagramBaseUrl = "http://www.instagram.com/"
        
        if inputProfile.text != "" {
            let username = inputProfile.text

            let url = URL(string: instagramBaseUrl + username!)

            let task = URLSession.shared.dataTask(with: url!) { (data, resp, error) in
                guard let data = data else {
                    print("Nil")
                    return
                }

                guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {
                    print("Cannot cast data into string")
                    return
                }
                
                // MARK: - Followrs
                
                let LeftFollower = """
                edge_followed_by":{"count":
                """
                let RightFollower = """
                },"followed_by_viewer"
                """
                guard let LeftFollowerRange = htmlString.range(of: LeftFollower) else {
                    print("cannot find left range")
                    return
                }
                guard let RightFollowerRange = htmlString.range(of: RightFollower) else {
                    print("cannot find right value")
                    return
                }
                let followerRange = LeftFollowerRange.upperBound..<RightFollowerRange.lowerBound

                // MARK: - Follows
                
                let LeftFollows = """
                edge_follow":{"count":
                """
                let RightFollows = """
                },"follows_viewer"
                """
                guard let LeftFollowsRange = htmlString.range(of: LeftFollows) else {
                    print("cannot find left range")
                    return
                }
                guard let RightFollowsRange = htmlString.range(of: RightFollows) else {
                    print("cannot find right value")
                    return
                }
                let followsRange = LeftFollowsRange.upperBound..<RightFollowsRange.lowerBound
                
                // MARK: - Bio
                
                let LeftBio = """
                {"biography":"
                """
                let RightBio = """
                ","blocked_by_viewer"
                """
                guard let LeftBioRange = htmlString.range(of: LeftBio) else {
                    print("cannot find left range")
                    return
                }
                guard let RightBioRange = htmlString.range(of: RightBio) else {
                    print("cannot find right value")
                    return
                }
                let bioRange = LeftBioRange.upperBound..<RightBioRange.lowerBound
                
                // MARK: - Website
                
                let LeftWebsite = """
                "external_url":"
                """
                let RightWebsite = """
                ","external_url_linkshimmed
                """
                guard let LeftWebsiteRange = htmlString.range(of: LeftWebsite) else {
                    print("cannot find left range")
                    return
                }
                guard let RightWebsiteRange = htmlString.range(of: RightWebsite) else {
                    print("cannot find right value")
                    return
                }
                let WebsiteRange = LeftWebsiteRange.upperBound..<RightWebsiteRange.lowerBound
                
                // MARK: - Vefified
                
                let LeftVefified = """
                "is_verified":
                """
                let RightVefified = """
                ,"edge_mutual_followed_by
                """
                guard let LeftVefifiedRange = htmlString.range(of: LeftVefified) else {
                    print("cannot find left range")
                    return
                }
                guard let RightVefifiedRange = htmlString.range(of: RightVefified) else {
                    print("cannot find right value")
                    return
                }
                let verifiedRange = LeftVefifiedRange.upperBound..<RightVefifiedRange.lowerBound
                
                // MARK: - Posts
                   
                let LeftPosts = """
                edge_owner_to_timeline_media":{"count":
                """
                let RightPosts = """
                ,"page_info":{"has_next_page"
                """
                guard let LeftPostsRange = htmlString.range(of: LeftPosts) else {
                    print("cannot find left range")
                    return
                }
                guard let RightPostsRange = htmlString.range(of: RightPosts) else {
                    print("cannot find right value")
                    return
                }
                //let PostsRange = LeftPostsRange.upperBound..<RightPostsRange.lowerBound
                
                
                // MARK: - Print Statements
                
                JSONData = "\(username!) {\n\tFollowers: \(htmlString[followerRange]) \n\tFollows: \(htmlString[followsRange]) \n\tBio: \(htmlString[bioRange]) \n\tSite: \(htmlString[WebsiteRange]) \n\tVerified?: \(htmlString[verifiedRange]) \n}"
                
                scrapedData=[
                    "Followers": String(htmlString[followerRange]),
                    "Follows": String(htmlString[followsRange]),
                    "Bio": String(htmlString[bioRange]),
                    "Site": String(htmlString[WebsiteRange]),
                    "Verified": String(htmlString[verifiedRange])]
                
                DispatchQueue.main.async { // Correct
                   self.jsonLabel.text = JSONData
                    self.dictionaryLabel.text = scrapedData.description
                }
                
            }

            task.resume()
            print(JSONData)
        }
        else{
            
        }
    }
    
}

