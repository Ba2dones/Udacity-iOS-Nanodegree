//
//  MemeDetailVC.swift
//  MemeMe2.0
//
//  Created by Hassan Mostafa on 5/17/19.
//  Copyright © 2019 Hassan Mostafa. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    // MARK: - Properties
    var meme: Meme!
    
    // MARK: - Outlets
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memedImage!.image = meme.memedImage
    }
    
}
