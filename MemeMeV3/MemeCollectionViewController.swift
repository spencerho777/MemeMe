//
//  MemeCollectionViewController.swift
//  MemeMeV3
//
//  Created by Van Nguyen on 8/13/18.
//  Copyright © 2018 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    let space: CGFloat = 3.0
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Sent Items"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navigateToEditor))
        
        flowLayout.minimumInteritemSpacing = self.space
        flowLayout.minimumLineSpacing = self.space
        
        setItemSize()
    }
    
    func setItemSize() {
        let width = (view.frame.size.width - (2 * self.space)) / 3.0
        flowLayout.itemSize = CGSize(width: width, height: width)
    }
    
    @objc func navigateToEditor() {
        let pictureSelectorVC = storyboard?.instantiateViewController(withIdentifier: "PictureSelectorViewController") as! PictureSelectorViewController
        
        present(pictureSelectorVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeItem", for: indexPath) as! CustomMemeItem
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController")as! DetailViewController
        
        detailVC.image = memes[(indexPath as NSIndexPath).row].memedImage
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        setItemSize()
    }
}
