//
//  HomeTabBarController.swift
//  RottenTomato
//
//  Created by Giao Tuan on 11/12/15.
//  Copyright © 2015 LiFish. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = ColorUtils.UIColorFromRGB("F77A74")

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
