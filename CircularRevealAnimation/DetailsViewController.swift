//
//  DetailsViewController.swift
//  CircularRevealAnimation
//
//  Created by Чингиз Б on 09.03.17.
//  Copyright © 2017 Chingiz Bayshurin. All rights reserved.
//



import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var actionPublicationDate: UILabel!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var actionFullDescription: UILabel!
    
    
    
    var actionPublicationDateName  = String()
    var actionImageName            = String()
    var actionTitleName            = String()
    var actionFullDescriptionName  = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionPublicationDate.text         = actionPublicationDateName
        actionImage.image = UIImage(named: actionImageName)
        actionTitle.text                   = actionTitleName
        actionFullDescription.text         = actionFullDescriptionName
        
        
        let  barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        
    }
    
    
    
    
    
}
