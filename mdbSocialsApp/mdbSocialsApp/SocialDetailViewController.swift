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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
