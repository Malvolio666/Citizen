//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit



class LeftViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    
    var allCategories:NSMutableArray! = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCategories.removeAllObjects()
        
        var findCategories:PFQuery = PFQuery(className: "categories")
        
        findCategories.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil{
                for object in objects{
                    let category:PFObject = object as! PFObject
                    self.allCategories.addObject(category)
                }
                
                let array:NSArray = self.allCategories
                self.allCategories = NSMutableArray(array: array)
                var descriptor: NSSortDescriptor = NSSortDescriptor(key: "rank", ascending: true)
                self.allCategories.sortUsingDescriptors([descriptor])
                
                self.tableView.reloadData()
                
            }
            
        }
        
        
        
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let category = self.allCategories[indexPath.row].objectForKey("name") as! NSString
                
                let navController = segue.destinationViewController as! UINavigationController
                
                let detailViewController = navController.topViewController as! DetailViewController
                
                detailViewController.categoryTitle = category
                
            }
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        //cell.backgroundColor = UIColor.blackColor()
        
        if indexPath.row == 0 {
            
            let dashboardCell = tableView.dequeueReusableCellWithIdentifier("dashboardCell", forIndexPath: indexPath) as! UITableViewCell
            
            dashboardCell.textLabel!.text = "SYNTHESE" as String
            
            return dashboardCell
            
        }
            
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            
            let category:PFObject = self.allCategories.objectAtIndex(indexPath.row) as! PFObject
            
            cell.textLabel!.text = category.objectForKey("name") as? String
            
            return cell
            
        }
        
    }
    
    
}