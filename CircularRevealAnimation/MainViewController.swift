//
//  MainViewController.swift
//  CircularRevealAnimation
//
//  Created by Чингиз Б on 09.03.17.
//  Copyright © 2017 Chingiz Bayshurin. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    
    @IBOutlet weak var collection: UICollectionView!
    
//    @IBOutlet weak var actionPublicationDate: UILabel!
//    @IBOutlet weak var actionTitle: UILabel!
//    @IBOutlet weak var actionImage: UIImageView!
//    @IBOutlet weak var actionShortDescription: UILabel!
    
    var currentIndex = 0
    var screenWidth  = CGFloat()
    var screenHeight = CGFloat()
    var melody = String()
    
    //для проигрывания музыки
    var audioPlayer = AVAudioPlayer()
    
    
    //MARK:  View Lifecicle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        let userDefaults = UserDefaults.standard
        
        if ( userDefaults.string(forKey: "melody_number" ) == nil) {
            userDefaults.set("2",  forKey: "melody_number")
            melody = "melody1"
        }
        else if ( userDefaults.string(forKey: "melody_number" ) == "1") {
            userDefaults.set("2",  forKey: "melody_number")
            melody = "melody1"
        }
        else if ( userDefaults.string(forKey: "melody_number" ) == "2") {
            userDefaults.set("3",  forKey: "melody_number")
            melody = "melody2"
        }
        else if ( userDefaults.string(forKey: "melody_number" ) == "3") {
            userDefaults.set("1",  forKey: "melody_number")
            melody = "melody3"
        }
        else {
            
        }*/
        
        
        
        collection.delegate = self
        collection.dataSource = self
        
        //добавляем обзервер на событие смены ориентации
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        screenWidth  = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        
        orientationChanged()
        
        //---- блок запуска проигрывания музыки --------------
        //06:34   https://www.youtube.com/watch?v=dqad3XuMwHI
        //do {
            
            
            
            
//            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: melody, ofType: "mp3")!  ))
//            audioPlayer.numberOfLoops = 1
//            audioPlayer.prepareToPlay()
            
            //тайминг 09:52 - штрихи, для того, чтобы при сворачивании
            //аппликации, музыка не прекращалась
            //https://www.youtube.com/watch?v=dqad3XuMwHI
            //var audioSession = AVAudioSession.sharedInstance()
            //do {
                //MARK: октлючить фоновое проигрывание try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            //}
            
//        }
//        catch {
//            print(error)
//        }
        //-------------------------------------------------
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let attributes = [NSFontAttributeName : UIFont(name: "Savoye LET", size: 38)!, NSForegroundColorAttributeName : UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.topItem?.title = "Honest Food"
        
        //self.navigationController?.navigationBar.titleTextAttributes = [
        //    NSForegroundColorAttributeName : UIColor.white
        //]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //когда все отрисовано - тогда и запускаем музыку
        //audioPlayer.play()
    }
    
    
    
    //MARK: ---- CollectionView ----------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Action.actionImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        
        //расчитываем индекс
        let curIndex = (Action.actionImages.count-1) - indexPath.row
        
        
        let actionPublicationDate   = cell.viewWithTag(1) as! UILabel
        let actionTitle             = cell.viewWithTag(2) as! UILabel
        
        let actionImage = cell.viewWithTag(3) as! UIImageView
        actionImage.image = UIImage(named: Action.actionImages[curIndex])
        actionImage.layer.masksToBounds = true
        actionImage.layer.cornerRadius = 10
        actionImage.isUserInteractionEnabled = true
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDetails))
        actionImage.addGestureRecognizer(tap)
        
        
        let actionDesciption        = cell.viewWithTag(4) as! UILabel
        actionPublicationDate.text  = Action.actionPublicationDates[curIndex]
        actionTitle.text            = Action.actionTitles[curIndex]
        actionDesciption.text       = Action.actionShortDescriptions[curIndex]
        
        
        return cell
    }
    
    
    
    
    func showDetails(sender: UITapGestureRecognizer) {
        //снимаем данные о том, из какой ячейки было нажатие
        var tapLocation = sender.location(in: self.collection)
        let indexPath:NSIndexPath = self.collection.indexPathForItem(at: tapLocation)! as NSIndexPath
        
        currentIndex = (Action.actionImages.count-1) - indexPath.row
        
        
        
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetails") {
            let vc = segue.destination as! DetailsViewController
            vc.actionPublicationDateName =     Action.actionPublicationDates[currentIndex]
            vc.actionImageName           =     Action.actionImages[currentIndex]
            vc.actionTitleName           =     Action.actionTitles[currentIndex]
            vc.actionFullDescriptionName =     Action.actionFullDescriptions[currentIndex]
        }
        
    }
    
    
    //MARK: ----- для смены ориентации --------------------------------------------
    func orientationChanged()
    {
        screenWidth  = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        print("CVET_DOMIK - SCREEN RESOLUTION: \(screenWidth.description) x \(screenHeight.description)")
        
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            print("landscape") // set frame for landscape
            redraw_collection(orientation: true)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            print("Portrait") // set frame for portrait
            redraw_collection(orientation: false)
        }
    }
    
    func redraw_collection(orientation : Bool) {
        var numberOfColumns : CGFloat
        if(!orientation) {
            numberOfColumns = 1.0
        } else {
            numberOfColumns = 2.0
        }
        NSLog("собираюсь сделать %f колонок", numberOfColumns)
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth  =  UIScreen.main.bounds.width / numberOfColumns - 3.0*numberOfColumns    //view.bounds.width / 2.0
            let itemHeight = itemWidth + 120                                    //layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    //-----------------------------------------------------------------------------
    
}//----end of class declaration

