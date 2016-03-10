//
//  ViewController.swift
//  mdbSocialsApp
//
//  Created by Shaan Appel on 3/8/16.
//  Copyright © 2016 Shaan Appel. All rights reserved.
//

import UIKit

class SocialsFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pathRow = 0
    
    var socialImages = [UIImage(named:"bowling"), UIImage(named:"bbq"), UIImage(named:"ideaSocial"), UIImage(named:"party"), UIImage(named:"hike")]
    
    var socialLabels = ["Friday Night Bowling", "Spring BBQ", "Idea Social", "Party!", "Big C Hike"]

    @IBOutlet weak var socialCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        socialCollectionView.delegate = self
        
        socialCollectionView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialImages.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = socialCollectionView.dequeueReusableCellWithReuseIdentifier("socialCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.socialImage.image = socialImages[indexPath.item]
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
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        pathRow = indexPath.row
        self.performSegueWithIdentifier("toSocialDetailVC", sender: indexPath)
    }
}