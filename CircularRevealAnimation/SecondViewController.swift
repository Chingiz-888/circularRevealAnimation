//
//  SecondViewController.swift
//  CircularRevealAnimation
//
//  Created by Чингиз Б on 11.03.17.
//  Copyright © 2017 Chingiz Bayshurin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    @IBAction func backButtonTapped(_ sender: Any) {
        print("Производим Undwind unwindSegue")
        performSegue(withIdentifier: "unwindSegueBack", sender: self)
    }

 
    
 

}
