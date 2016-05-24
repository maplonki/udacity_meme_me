//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Hugo Murillo on 5/14/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var sentMemes: [MemeModel]!
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentMemes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(createMemePressed(_:)))
        
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let spacing: CGFloat = 2.0
        //We set size to 3 columns, dividing the parent's width
        //and multiplying for 2 sides the spacing
        
        let cellSize: CGFloat!
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            cellSize = (view.frame.height - (2 * spacing)) / 3.0
        } else {
         cellSize = (view.frame.width - (2 * spacing)) / 3.0
        }
        collectionViewFlowLayout.minimumLineSpacing = spacing
        collectionViewFlowLayout.minimumInteritemSpacing = spacing
        collectionViewFlowLayout.itemSize = CGSizeMake(cellSize, cellSize)
    }
    
    //MARK: Selectors
    func createMemePressed(sender: AnyObject?) {
        performSegueWithIdentifier("createSegue", sender: nil)
    }
    
    //MARK: UICOllectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = sentMemes[indexPath.row]
        
        let tableCell:MemeCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        tableCell.cellImage.image = item.image
        return tableCell
    }
    
    //MARK: UICOllectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let meme = sentMemes[indexPath.row] as MemeModel
        performSegueWithIdentifier("detailSegue", sender: meme)
    }
    
    //MARK: Navigation Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destinationViewController as! MemeDetailViewController
            detailVC.detailImage = (sender as! MemeModel).image
        } else if segue.identifier == "createSegue" {
            if let storyboard = storyboard {
                let createVC = storyboard.instantiateViewControllerWithIdentifier("CreateMemeViewController")
                presentViewController(createVC, animated: true, completion: nil)
            }
        }
    }
}
