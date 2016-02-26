//
//  OptionsViewController.swift
//  Mapper
//
//  Created by hollarab on 2/28/16.
//  Copyright © 2016 a. brooks hollar. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet var useLargeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }


    // MARK: - Notifications
    func dataUpdated() {
        updateUI()
    }

    // MARK: - User Interaction
    @IBAction func switchValueChanged(sender: AnyObject) {
        
    }

    
    /// Load Model into View
    func updateUI() {
        
    }
    
    
}
