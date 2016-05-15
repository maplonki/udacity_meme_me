//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Hugo Murillo on 5/14/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var sentMemes: [MemeModel]!
    
    //MARK: Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(createMemePressed(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        sentMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
    }
    
    //MARK: Selectors
    func createMemePressed(sender: AnyObject?) {
        if let storyboard = self.storyboard {
            let createVC = storyboard.instantiateViewControllerWithIdentifier("CreateMemeViewController")
            presentViewController(createVC, animated: true, completion: nil)
        }
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableCell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("memeTableViewCell")
        let meme = sentMemes[indexPath.row]
        tableCell.textLabel?.text = meme.topText + meme.bottomText
        tableCell.imageView?.image = meme.originalImage
        return tableCell
    }
    
    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = sentMemes[indexPath.row] as MemeModel
        performSegueWithIdentifier("detailSegue", sender: meme)
    }
    
    //MARK: Navigation Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destinationViewController as! MemeDetailViewController
            detailVC.detailImage = (sender as! MemeModel).image
        }
    }
}
