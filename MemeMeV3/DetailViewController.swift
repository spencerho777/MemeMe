//
//  DetailViewController.swift
//  MemeMeV3
//
//  Created by Van Nguyen on 8/18/18.
//  Copyright © 2018 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.tabBarController?.tabBar.isHidden = true
    }
}
