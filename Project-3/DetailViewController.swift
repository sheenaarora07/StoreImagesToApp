//
//  DetailViewController.swift
//  Project-3
//
//  Created by Sheena on 18/02/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedImage: Picture?
    var path: URL!

    @IBOutlet var name: UITextField!
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        name.text = selectedImage?.name
        image.image = UIImage(contentsOfFile: path.path)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.hidesBarsOnTap = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.hidesBarsOnTap = false
        }


}
