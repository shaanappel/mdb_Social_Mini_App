//
//  NewSocialViewController.swift
//  mdbSocialsApp
//
//  Created by Jessica  Cherny on 3/8/16.
//  Copyright © 2016 Shaan Appel. All rights reserved.
//

import UIKit

class NewSocialViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var titleText: UITextField!
    
    
    @IBOutlet weak var location: UITextField!

    
    @IBOutlet weak var socialDescription: UITextField!
    
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var socialPicture: UIImageView!
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayAlert(title: String, displayError: String) {
        
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date.keyboardType = UIKeyboardType.PhonePad
        date.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(textField: UITextField) {
        if date.text!.characters.count == 2 {
            date.text = date.text! + "/"
        }
        if date.text!.characters.count == 5 {
            date.text = date.text! + "/"
        }
    }
    
    @IBAction func post(sender: AnyObject) {
        
//        stores the social’s info in the
//        
//        database, and then takes the user back to the SocialsFeedViewController.
        
        
        let dataString = date.text! as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        // convert string into date
        let dateValue = dateFormatter.dateFromString(dataString) as NSDate!
        
        
        
        
        var displayError = ""
        if titleText.text == "" {
            displayError = "Please enter a Social Event name"
        } else if socialDescription.text == "" {
            displayError = "Please enter a description"
        } else if location.text == "" {
            displayError = "Please enter a location"
        }  else if date.text == "" {
            displayError = "Please enter a date"
        }  else if dateValue == nil {
            displayError = "Please enter a valid date"
        }
        
        if displayError != "" {
            displayAlert("Incomplete Form", displayError: displayError)
        } else {
            var newSocial = PFObject(className:"Socials")
            newSocial["socialTitle"] = titleText.text!
            newSocial["socialInformation"] = socialDescription.text!
            newSocial["socialLocation"] = location.text!
            newSocial["socialTime"] = dateValue
            
            
            
            
            let socialPicFile = PFFile(name: "socialPic.jpg", data: UIImageJPEGRepresentation(socialPicture.image!, 0.5)!)
            
            newSocial["socialPicture"] = socialPicFile
            
            
            newSocial.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("sucesssss!!!!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    // There was a problem, check error.description
                    if let theError = error!.userInfo["error"] as? NSString {
                        displayError = theError as String
                    } else {
                        displayError = "Please try again later!"
                    }
                    self.displayAlert("Could Not Signup", displayError: displayError)
                }
            }
        }

        
    }

    @IBAction func upload(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        socialPicture.image = image
        
        socialPicture.layer.cornerRadius = socialPicture.frame.size.width/2
        socialPicture.clipsToBounds = true
        
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
