//
//  MemeTableViewController.swift
//  MemeMeV3
//
//  Created by Van Nguyen on 8/13/18.
//  Copyright © 2018 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Sent Items"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navigateToEditor))
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    @objc func navigateToEditor() {
        let pictureSelectorVC = storyboard?.instantiateViewController(withIdentifier: "PictureSelectorViewController") as! PictureSelectorViewController
        
        present(pictureSelectorVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! CustomMemeCell
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        
        cell.topTextLabel?.text = meme.topText != "" ? meme.topText : "Top text"
        
        cell.bottomTextLabel?.text = meme.bottomText != "" ? meme.bottomText : "Bottom text"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController")as! DetailViewController
        
        detailVC.image = memes[(indexPath as NSIndexPath).row].memedImage
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}



