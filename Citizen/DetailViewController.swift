//
//  DetailViewController.swift
//  TestsNav
//
//  Created by Mickaël Jordan on 17/02/15.
//  Copyright (c) 2015 Mickaël Jordan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var postView: UITableView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    var titles = [String]()
    var metricValues = [String]()
    var metricUnits = [String]()
    var evolutionValues = [String]()
    var evolutionUnits = [String]()
    var evolutionDurations = [String]()
    var sources = [String]()
    var dates = [String]()
    var charts = [UIImage]()
    var chartFiles = [PFFile]()
    var backgroundFiles = [PFFile]()
    var categoryTitle = NSString()
    
    override func viewDidLayoutSubviews() {
        
        postView.layoutMargins = UIEdgeInsetsZero
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        var findPosts:PFQuery = PFQuery(className: "posts")
        findPosts.whereKey("category", equalTo: categoryTitle)
        findPosts.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil{
                
                for object in objects{
                
                    self.titles.append(object["title"] as! String)
                    self.metricValues.append(object["metricValue"] as! String)
                    self.metricUnits.append(object["metricUnit"] as! String)
                    self.evolutionValues.append(object["evolutionValue"]as! String)
                    self.evolutionUnits.append(object["evolutionUnit"] as! String)
                    self.evolutionDurations.append(object["evolutionDuration"] as! String)
                    self.sources.append(object["source"] as! String)
                    self.dates.append(object["publishedAt"] as! String)
                    self.chartFiles.append(object["chart"] as! PFFile)
                    self.postView.reloadData()
                
                }
                    
                } else {
                
                println(error)
            
            }
            
        }
        
        var findCategories:PFQuery = PFQuery(className: "categories")
        findCategories.whereKey("name", equalTo: categoryTitle)
        findCategories.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil{
                
                for object in objects{
                    
                    self.backgroundFiles.append(object["image"]as! PFFile)
                    
                }
                
            } else {
                
                println(error)
                
            }
            
            
        }
        
        self.postView.estimatedRowHeight = 600.0
        self.postView.rowHeight = UITableViewAutomaticDimension
    
    }
    
    
    func tableView(postView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    
    func tableView(postView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var customCell:cell = self.postView.dequeueReusableCellWithIdentifier("cell") as! cell
        
        customCell.layoutMargins = UIEdgeInsetsZero
        
        customCell.postTitle.text = titles[indexPath.row]
        
        customCell.postMetric.text = metricValues[indexPath.row] + metricUnits[indexPath.row]
        
        customCell.postEvolution.text = evolutionValues[indexPath.row] + evolutionUnits[indexPath.row] + " " + evolutionDurations[indexPath.row]
        
        customCell.postSource.text = sources[indexPath.row] + ", " + dates[indexPath.row]
        
        chartFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData)!
                
                customCell.indentationLevel = 0
                
                let size = image.size
                
                let ratio = size.width/size.height
                
                let height = customCell.postChart.frame.size.width/ratio
                
                let f = customCell.postChart.frame
                
                let frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, height)
                
                customCell.postChart.image = image
                
                //customCell.postChart.frame = frame
                
                customCell.heightConstraint.constant = height
                
                customCell.postChart.image = image
        
            
            }
            
            
        }
        
        return customCell
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        navigationController?.navigationBar.topItem?.title = categoryTitle as String
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        navigationController?.navigationBar.translucent = false
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        /*backgroundFiles[0].getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                
                let backgroundImage = UIImage(data: imageData)!
                
                self.background.image = backgroundImage
                
            }
            
        }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

