//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Hugo Murillo on 5/14/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var detailImage: UIImage!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
        detailImageView.image = detailImage
    }
}
