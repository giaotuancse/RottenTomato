//
//  MovieViewController.swift
//  RottenTomato
//
//  Created by Giao Tuan on 11/10/15.
//  Copyright © 2015 LiFish. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftLoader

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var movieTableView: UITableView!
    
    let url = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214";
    var movieData = [NSDictionary]()
    var refreshControl:UIRefreshControl!
    
    var selectedMovie = NSDictionary()
    
    var searchActive : Bool = false
    var filterMovie = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ColorUtils.UIColorFromRGB("F77A74");
        navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName: UIColor.whiteColor()];
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "fecthMovie", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView.addSubview(refreshControl)
        
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
        self.searchBar.delegate = self
        
        actionShowLoader()
        fecthMovie()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()

        // Do any additional setup after loading the view.
    }

    // show dialog loading
    func actionShowLoader() {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = ColorUtils.UIColorFromRGB("F77A74")
        config.titleTextColor = ColorUtils.UIColorFromRGB("F77A74")
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.blackColor()
        config.foregroundAlpha = 0.5
        
        
        SwiftLoader.setConfig(config)
        SwiftLoader.show(title: "Loading...", animated: false)
      
     
        
    }


    func networkStatusChanged(notification: NSNotification) {
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            print("Not connected")
            networkErrorView.hidden = false
        case .Online(.WWAN):
            print("Connected via WWAN")
            networkErrorView.hidden = true
        case .Online(.WiFi):
            print("Connected via WiFi")
            networkErrorView.hidden = true

        }
    }
 
       
    
    func fecthMovie(){
        print("GO TO FETCH MOVIE")
        let nsUrl = NSURL(string : url)!;
        let connection = NSURLRequest(URL: nsUrl)
        
        // Reuqest by NSURLConnection
        /*NSURLConnection.sendAsynchronousRequest(connection, queue: NSOperationQueue.mainQueue()) { (response : NSURLResponse?, data : NSData?, error : NSError?) -> Void in
        do {
        let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
        print(jsonData)
        // use jsonData
        } catch {
        // report error
        }
        }*/
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(connection) { (data : NSData?,  response :NSURLResponse?, error : NSError?) -> Void in
            guard error == nil else  {
                print("error loading from URL", error!)
                return
            }
            // do something here
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: [] ) as? NSDictionary
                //print(jsonData)
                self.movieData = jsonData!["movies"] as! [NSDictionary]
                // use jsonData
            } catch {
                // report error
                print(error)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.movieTableView.reloadData()
                if self.refreshControl.refreshing {
                    self.refreshControl.endRefreshing()
                }
                SwiftLoader.hide()
            })
            
            
            
        }
        task.resume()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filterMovie.count
        }
        return movieData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
       // self.performSegueWithIdentifier("showView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender:
        AnyObject?)
    {
            let cell = sender as! MovieItemCell
            // upcoming is set to NewViewController (.swift)
            let upcomingViewControler: DetailViewController = segue.destinationViewController
                as! DetailViewController
            // indexPath is set to the path that was tapped
            let indexPath = self.movieTableView.indexPathForSelectedRow!
            var movieDataInTime = [NSDictionary]()
        if (searchActive) {
            movieDataInTime = filterMovie
        } else {
            movieDataInTime = movieData
        }
            upcomingViewControler.selectedMovie = movieDataInTime[indexPath.row] as NSDictionary
            upcomingViewControler.posterPlaceHolder = cell.posterImageView.image
            upcomingViewControler.hidesBottomBarWhenPushed = true
            self.movieTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.navigationController?.title = "Back"
        //}
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.movieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieItemCell
        var movieDataInTime = [NSDictionary]()
        if (searchActive) {
            movieDataInTime = filterMovie
        } else {
            movieDataInTime = movieData
        }
        
        let movieItem = movieDataInTime[indexPath.row]
        cell.titleLabel.text = movieItem["title"] as? String
        cell.sysnosypLabel.text = movieItem["synopsis"] as? String
        //cell.sysnosypLabel.sizeToFit()
        let year = movieItem["year"] as! Int
        
        cell.yearsLabel.text = "\(year) - \(movieItem["mpaa_rating"] as! String) "
        let posterDic = movieItem["posters"] as! NSDictionary
        let thumbnailUrl = NSURL(string : posterDic["thumbnail"] as! String)!;
        cell.posterImageView.setImageWithURL(thumbnailUrl)
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
      //  title = "Movies"
        navigationController?.topViewController?.title = "Movies"
       view.endEditing(true)
    }

    //Search bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            searchActive = false;
            
        } else {
              searchActive = true;
        }
        print("searchBarTextDidBeginEditing - true")
      
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        if searchBar.text!.isEmpty {
//            searchActive = false;
//            searchBar.resignFirstResponder()
//        } else {
//            searchActive = true;
//        }
//         print("searchBarTextDidEndEditing - true")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked - false")
        searchBar.resignFirstResponder()
        searchActive = false;
        movieTableView.reloadData()
        view.endEditing(true);
       
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked - true")
        searchActive = true;
        view.endEditing(true);

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            print("isEmpty - false")
            searchActive = false;
            view.endEditing(true);
            movieTableView.reloadData();
            return
        }
        filterMovie = movieData.filter({ (movie) -> Bool in
            let tmp: NSDictionary = movie
            let range = tmp["title"]!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        print("searchBar - true")
        searchActive = true;
        movieTableView.reloadData();
        

            }
}
