//
//  SocialDetailViewController.swift
//  mdbSocialsApp
//
//  Created by Jessica  Cherny on 3/8/16.
//  Copyright © 2016 Shaan Appel. All rights reserved.
//

import UIKit

class SocialDetailViewController: UIViewController {
    var eventLabelText = ""
    var socialId = ""
    var currentUser = PFUser.currentUser()
    var goingAry = Array<String>()
    var notGoingAry = Array<String>()
    
   
    @IBOutlet weak var namesTableView: UITableView!
    @IBOutlet weak var socialDescription: UILabel!
    
    @IBOutlet weak var socialDate: UILabel!
    @IBOutlet weak var socialLocation: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var goingButton: UIButton!

    @IBOutlet weak var notGoingButton: UIButton!
    
    
    @IBOutlet weak var socialPicture: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventLabel.text = eventLabelText
        
        socialPicture.layer.cornerRadius = socialPicture.frame.size.width/2
        socialPicture.clipsToBounds = true
        socialPicture.contentMode = .ScaleAspectFill

        getSocialInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSocialInfo() {
        // Write query to get the info of the user with the most hits. Then set the respective fields' values.
        let query = PFQuery(className:"Socials")
        query.getObjectInBackgroundWithId(socialId) {
            (social: PFObject?, error: NSError?) -> Void in
            if error == nil && social != nil {
                let imageFile = social!["socialPicture"] as! PFFile
                imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        let image1 = UIImage(data: imageData!)
                        self.socialPicture.image = image1
                    }
                }
                self.socialDescription.text = social!["socialInformation"] as? String
                self.socialLocation.text = social!["socialLocation"] as? String
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                let dateString =  dateFormatter.stringFromDate((social!["socialTime"] as? NSDate)!)
                self.socialDate.text = dateString
                
                
            } else {
                print(error)
            }
        }
        
    }
    
    @IBAction func hitGoing(sender: AnyObject) {
        let query = PFQuery(className:"Socials")
        query.getObjectInBackgroundWithId(socialId) {
            (social: PFObject?, error: NSError?) -> Void in
            if error == nil && social != nil {
                self.goingAry = (social!["goingUserObjectIds"] as? Array<String>)!
                self.notGoingAry = (social!["notGoingUserObjectIds"] as? Array<String>)!

                if self.goingAry.contains((self.currentUser?.objectId)!) {
                    print("Already going")
                } else {
                    self.goingAry.append(((self.currentUser?.objectId)!))
                }
                if self.notGoingAry.contains((self.currentUser?.objectId)!) {
                    let indexOfItem = self.notGoingAry.indexOf((self.currentUser?.objectId)!)
                    self.notGoingAry.removeAtIndex(indexOfItem!)
                }
                social!["goingUserObjectIds"] = self.goingAry
                social!["notGoingUserObjectIds"] = self.notGoingAry
                
                
            } else {
                print(error)
            }
        }
        
    }
    
    
    @IBAction func hitNotGoing(sender: AnyObject) {
        let query = PFQuery(className:"Socials")
        query.getObjectInBackgroundWithId(socialId) {
            (social: PFObject?, error: NSError?) -> Void in
            if error == nil && social != nil {
                self.goingAry = (social!["goingUserObjectIds"] as? Array<String>)!
                self.notGoingAry = (social!["notGoingUserObjectIds"] as? Array<String>)!
                if self.notGoingAry.contains((self.currentUser?.objectId)!) {
                    print("Already Not going")
                } else {
                    self.notGoingAry.append(((self.currentUser?.objectId)!))
                }
                if self.goingAry.contains((self.currentUser?.objectId)!) {
                    let indexOfItem = self.goingAry.indexOf((self.currentUser?.objectId)!)
                    self.notGoingAry.removeAtIndex(indexOfItem!)
                }
                social!["goingUserObjectIds"] = self.goingAry
                social!["notGoingUserObjectIds"] = self.notGoingAry
                
                
            } else {
                print(error)
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
