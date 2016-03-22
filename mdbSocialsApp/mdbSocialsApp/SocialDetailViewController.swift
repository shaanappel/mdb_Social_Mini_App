//
//  SocialDetailViewController.swift
//  mdbSocialsApp
//
//  Created by Jessica  Cherny on 3/8/16.
//  Copyright © 2016 Shaan Appel. All rights reserved.
//

import UIKit

class SocialDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var eventLabelText = ""
    var socialId = ""
    var currentUser = PFUser.currentUser()
    var goingAry = Array<String>()
    var notGoingAry = NSMutableArray()
    var namesAry = Array<String>()
    
   
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
        namesTableView.delegate = self
        namesTableView.dataSource = self
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesAry.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = namesTableView.dequeueReusableCellWithIdentifier("socialDetailCell", forIndexPath: indexPath) as! SocialDetailViewCell
        
        cell.nameLabel.text = namesAry[indexPath.item]
        
        return cell
    }
    
    func updateNamesAry (ary: NSArray) {
        let query = PFQuery(className:"User")
        query.whereKey("objectId", containedIn: ary as [AnyObject])
        
        query.findObjectsInBackgroundWithBlock { //findObjects in association with whereKey
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.namesAry.append(object["firstName"] as! String)
                    }
                    self.namesTableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getSocialInfo() {
        // Write query to get the info of the user with the most hits. Then set the respective fields' values.
        namesAry.removeAll()
        
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
                var ary = NSArray()
                if social?["goingUserObjectIds"] != nil {
                    
                    ary = social?["goingUserObjectIds"] as! NSArray
                    print(ary)
                    
                }
                
                for objectId in ary {
                    let query = PFQuery(className:"_User")
                    query.whereKey("objectId", equalTo: objectId as! String)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            // The find succeeded.
                            print("Successfully retrieved \(objects!.count) scores.")
                            // Do something with the found objects
                            if let objects = objects {
                                for object in objects {
                                    self.namesAry.append(object["firstName"] as! String)
                                }
                                self.namesTableView.reloadData()
                            }
                        } else {
                            // Log details of the failure
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                    }
                    
                }
                self.namesTableView.reloadData()
                
                
                
                
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
                social!.addUniqueObject((self.currentUser?.objectId)!, forKey:"goingUserObjectIds")
                social!.saveInBackground()
                social!.removeObject((self.currentUser?.objectId)!, forKey:"notGoingUserObjectIds")
                social!.saveInBackground()
                
                print((self.currentUser?.objectId)!)
                
                let query = PFQuery(className:"_User")
                query.whereKey("objectId", equalTo: (self.currentUser?.objectId)!)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) scores.")
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                if !self.namesAry.contains(object["firstName"] as! String) {
                                    self.namesAry.append(object["firstName"] as! String)
                                }
                            }
                            self.namesTableView.reloadData()
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                
                self.namesTableView.reloadData()
                
                
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
                social!.addUniqueObject((self.currentUser?.objectId)!, forKey:"notGoingUserObjectIds")
                social!.saveInBackground()
                social!.removeObject((self.currentUser?.objectId)!, forKey:"goingUserObjectIds")
                social!.saveInBackground()
                
                
                let query = PFQuery(className:"_User")
                query.whereKey("objectId", equalTo: (self.currentUser?.objectId)!)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) scores.")
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                if self.namesAry.contains(object["firstName"] as! String) {
                                    let indexOfItem = self.namesAry.indexOf(object["firstName"] as! String)
                                    self.namesAry.removeAtIndex(indexOfItem!)
                                }
                            }
                            self.namesTableView.reloadData()
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                
                self.namesTableView.reloadData()
                
                
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
