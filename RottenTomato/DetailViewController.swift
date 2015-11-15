//
//  DetailViewController.swift
//  RottenTomato
//
//  Created by Giao Tuan on 11/13/15.
//  Copyright © 2015 LiFish. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pgLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    
    var selectedMovie: NSDictionary!
    var posterPlaceHolder : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedMovie["title"] as? String
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.posterImageView.image = self.posterPlaceHolder
       
        // init data
        synopsisLabel.text = selectedMovie["synopsis"] as? String
        synopsisLabel.sizeToFit()
        titleLabel.text = "\(selectedMovie["title"] as! String) - \(selectedMovie["year"] as! Int)"
        pgLabel.text = selectedMovie["mpaa_rating"] as? String
        pgLabel.layer.borderWidth = 0.5
        pgLabel.layer.cornerRadius = 8
        pgLabel.layer.borderColor = UIColor.blackColor().CGColor
        let criticScore = selectedMovie.valueForKeyPath("ratings.critics_score") as! Int
        let audienceScore = selectedMovie.valueForKeyPath("ratings.audience_score") as! Int
        ratingLabel.text = "Crictic Score: \(criticScore) - Audience Score: \(audienceScore)"
        bottomScrollView.contentSize.height = 130 + synopsisLabel.layer.frame.height
        
        // Load image with AFNetworking
        let fullURL = selectedMovie.valueForKeyPath("posters.detailed") as! String
        let fullNSURL = NSURL(string: fullURL)
        let request = NSURLRequest(URL: fullNSURL!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10)
        posterImageView.setImageWithURLRequest(request, placeholderImage: posterPlaceHolder, success: { (request: NSURLRequest, response :NSHTTPURLResponse?, image :UIImage) -> Void in
             self.posterImageView.alpha = 0.0;
             UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                 self.posterImageView.alpha = 1.0
                }, completion: nil)
             self.posterImageView.image = image
            }) { (request : NSURLRequest, response : NSHTTPURLResponse?, error : NSError) -> Void in
                   
            
        }
        
        addGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gusture for detail view 
    func addGesture() {
        let tapScrollView = UITapGestureRecognizer(target: self, action: "expandDetail:")
        self.bottomScrollView.addGestureRecognizer(tapScrollView)
        
        posterImageView.userInteractionEnabled = true
        let tapPoster = UITapGestureRecognizer(target: self, action: "collapseDetail:")
        self.posterImageView.addGestureRecognizer(tapPoster)
        
    }
    func expandDetail(sender:UITapGestureRecognizer) {
        print("expand")
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.bottomScrollView.frame = CGRectMake(0 , 300, self.view.frame.width, 270)
            }, completion: nil)
    }
    
    func collapseDetail(sender:UITapGestureRecognizer) {
        print("collapse")
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.bottomScrollView.frame = CGRectMake(0 , 400, self.view.frame.width, 170)
            }, completion: nil)
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
