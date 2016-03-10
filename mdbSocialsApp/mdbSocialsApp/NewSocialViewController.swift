//
//  NewSocialViewController.swift
//  mdbSocialsApp
//
//  Created by Jessica  Cherny on 3/8/16.
//  Copyright © 2016 Shaan Appel. All rights reserved.
//

import UIKit

class NewSocialViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var location: UITextField!

    @IBOutlet weak var time: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var date: UITextField!
    
    @IBAction func goBack(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post(sender: AnyObject) {
        
//        stores the social’s info in the
//        
//        database, and then takes the user back to the SocialsFeedViewController.
        
//        let user = PFUser()
//        user.titleText = titleText.text
//        user.location = location.text
//        user.time = time.text
//        user.date = date.text
        
    }

    @IBAction func upload(sender: AnyObject) {
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
