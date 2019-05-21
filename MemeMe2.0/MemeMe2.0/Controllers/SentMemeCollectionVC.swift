//
//  SentMemeCollectionVC.swift
//  MemeMe2.0
//
//  Created by Hassan Mostafa on 5/18/19.
//  Copyright © 2019 Hassan Mostafa. All rights reserved.
//

import UIKit


class SentMemeCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Sent Memes", style: .plain, target: nil, action: nil)
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let memeIndex = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage?.image = memeIndex.memedImage
        print(self.memes.count)
        return cell
    }
    
    // MARK: - Go to Meme Detail View
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    // MARK: - Add button to Meme Editor
    @IBAction func createMeme(_ sender: Any) {
        performSegue(withIdentifier: "createFromCollection", sender: sender)
    }
    
    
}
