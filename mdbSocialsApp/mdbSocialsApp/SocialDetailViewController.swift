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
    
   
    @IBOutlet weak var namesTableView: UITableView!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var goingButton: UIButton!

    @IBOutlet weak var notGoingButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
