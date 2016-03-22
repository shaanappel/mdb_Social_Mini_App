//
//  ViewController.swift
//  mdbSocialsApp
//
//  Created by Jessica Cherny on 3/8/16.
//  Copyright © 2016 Jessica Cherny. All rights reserved.
//

import UIKit

class SocialsFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pathRow = 0
    
    var socialIds = Array<String>()
    
    var socialImages = Array<PFFile>()
    
    var socialLabels = Array<String>()

    @IBOutlet weak var socialCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        socialCollectionView.delegate = self
        
        socialCollectionView.dataSource = self
        
        getSocials()
        getSocialPics()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //socialImages.removeAll()
        //socialLabels.removeAll()
        //socialIds.removeAll()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSocialPics() {
        // Get the profile pictures of all the members and add them to the profPics array. Then reload the tableview.
        let query = PFQuery(className: "Socials")
        do {
            let objects = try query.findObjects()
            for object in objects {
                socialImages.append(object["socialPicture"] as! PFFile)
            }
        } catch {
            print("Error")
        }
        socialCollectionView.reloadData()
    }
    
    func getSocials() {
        // Get the list of all the social titles and add them to the socialLabels array. Then reload the collectionview.
        let query = PFQuery(className:"Socials")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) socials.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.socialLabels.append(object["socialTitle"] as! String)
                        self.socialIds.append(object.objectId!)
                    }
                    self.socialCollectionView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialLabels.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = socialCollectionView.dequeueReusableCellWithReuseIdentifier("socialCell", forIndexPath: indexPath) as! CollectionViewCell
        
        // Set the image of the socialImage imageview in the cell
        socialImages[indexPath.row].getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                let image1 = UIImage(data: imageData!)
                cell.socialImage.image = image1
            }
            
        }
        
        cell.socialLabel.text = socialLabels[indexPath.item]
        cell.socialImage.contentMode = .ScaleAspectFill
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSocialDetailVC" {
            let vc = segue.destinationViewController as! SocialDetailViewController
            let row = pathRow
            let label = socialLabels[row]
            vc.eventLabelText = label
            vc.socialId = socialIds[row]
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        pathRow = indexPath.row
        self.performSegueWithIdentifier("toSocialDetailVC", sender: indexPath)
    }
}