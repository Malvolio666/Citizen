//
//  DetailViewController.swift
//  TestsNav
//
//  Created by Mickaël Jordan on 17/02/15.
//  Copyright (c) 2015 Mickaël Jordan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var categories = [String]()
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
    
    

    override func viewDidLayoutSubviews() {
        
        tableView.layoutMargins = UIEdgeInsetsZero
        
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
        findPosts.whereKey("inDashboard", equalTo: true).addAscendingOrder("rank")
        findPosts.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil{
                
                for object in objects{
                
                    self.categories.append(object["category"] as! String)
                    self.titles.append(object["title"] as! String)
                    self.metricValues.append(object["metricValue"] as! String)
                    self.metricUnits.append(object["metricUnit"] as! String)
                    self.evolutionValues.append(object["evolutionValue"]as! String)
                    self.evolutionUnits.append(object["evolutionUnit"]as! String)
                    self.evolutionDurations.append(object["evolutionDuration"] as! String)
                    self.sources.append(object["source"] as! String)
                    self.dates.append(object["publishedAt"] as! String)
                    self.chartFiles.append(object["chart"] as! PFFile)
                    
                    self.tableView.reloadData()
                
                }
                    
                } else {
                
                println(error)
            
                }
            
            
        }
        
        
        self.tableView.estimatedRowHeight = 670.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
    
    }
    
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var cell: UITableViewCell = sender as UITableViewCell
        var table: UITableView = cell.superview as UITableView
        let indexPath = table.indexPathForCell(cell)! as NSIndexPath
                
        let category = self.categories[indexPath.row]
        
        (segue.destinationViewController as DetailViewController).categoryTitle = category
        
    }*/
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var myCell:dashboardCell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as! dashboardCell
        
        myCell.layoutMargins = UIEdgeInsetsZero
        
        myCell.postCategory.text = categories[indexPath.row]
        
        myCell.postTitle.text = titles[indexPath.row]
        
        myCell.postMetric.text = metricValues[indexPath.row] + metricUnits[indexPath.row]
        
        myCell.postEvolution.text = evolutionValues[indexPath.row] + evolutionUnits[indexPath.row] + " " + evolutionDurations[indexPath.row]
        
        myCell.postSource.text = sources[indexPath.row] + ", " + dates[indexPath.row]
        
        chartFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData)!
                
                let size = image.size
                
                let ratio = size.width/size.height
    
                let height = myCell.postChart.frame.size.width/ratio
                
                
                
                let f = myCell.postChart.frame
                
                let frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, height)
                
                myCell.postChart.image = image
                
                //myCell.postChart.frame = frame
                
                myCell.heightConstraint.constant = height
        
            
            }
            
            
        }
        
        return myCell
        
        
        
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        navigationController?.navigationBar.topItem?.title = "SYNTHESE"
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        navigationController?.navigationBar.translucent = false
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

