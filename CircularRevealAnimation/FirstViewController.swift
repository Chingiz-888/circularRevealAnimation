//===== ViewController =================================================
//должны быть ViewController и SecondViewController



import UIKit
import Canvas


class FirstViewController: UIViewController {

    // MARK: Аутлеты для нас ================
    // Outlets for selected buttons
    @IBOutlet weak var firstButton  : UIButton!
    @IBOutlet weak var secondButton : UIButton!
    @IBOutlet weak var thirdButton  : UIButton!
    @IBOutlet weak var fourthButton : UIButton!
   
    //наш анимационный слой из Canvas pod
    @IBOutlet var animView: CSAnimationView!
    
    // Transition
    let transition = PopAnimator()                                // <<<< Вот этим кастомный объектом, который реализует протокол
                                                                  // UIViewControllerAnimatedTransitioning из
                                                                  // UIViewControllerTransitioningDelegate  мы и задаем анимацию
    
    // Reference for selected button
    var selectedButton : UIButton!
    var gotCenter : CGPoint?
    
    
    //обратный сегвей
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue) {}      // <<<< ВОТ ТУТ ВАЖНО ЧТОБЫ БЫЛО ПУСТОЕ ТЕЛО, КАК И САМ ОБРАТНЫЙ СЕГВЕЙ
    @IBAction func animationBtnTouched(_ sender: Any) {
        animView.startCanvasAnimation()
    }
    
    
    
    //MARK: эта функция может убирать полоску с зарядом батарерии и сетью
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: View Lifecircle ===============
    override func viewDidLoad() {
        super.viewDidLoad()

        animView.duration = 0.8
        animView.delay = 0.0
        animView.type = "shake"
    }
    override func viewDidAppear(_ animated: Bool) {
         selectedButton = firstButton //MARK: делаем так
    }
    

    
    
    @IBAction func firstButtonTapped(_ sender: UIButton?) {
        self.selectedButton = sender
        
        gotCenter = sender?.frame.origin
        if( gotCenter != nil ) {  NSLog( "\(gotCenter!)" ) }
       
        
        performSegue(withIdentifier: "animatedSegue", sender: self)
    }
    @IBAction func secondButtonTapped(_ sender: UIButton?) {
         self.selectedButton = sender
        
        gotCenter = sender?.frame.origin
        if( gotCenter != nil ) {  NSLog( "\(gotCenter!)" ) }
        
        
         performSegue(withIdentifier: "animatedSegue", sender: self)
    }
    @IBAction func thirdButtonTapped(_ sender: UIButton?) {
        self.selectedButton = sender
 
        gotCenter = sender?.frame.origin
        if( gotCenter != nil ) {  NSLog( "\(gotCenter!)" ) }
        
         performSegue(withIdentifier: "animatedSegue", sender: self)
    }
    @IBAction func fourthButtonTapped(_ sender: UIButton?) {
        self.selectedButton = sender
        
        gotCenter = sender?.frame.origin
        if( gotCenter != nil ) {  NSLog( "\(gotCenter!)" ) }
        
    
        
         performSegue(withIdentifier: "animatedSegue", sender: self)
    }
    
    
    
        

        

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SecondViewController {
            //set transioning delegate and modal presentation style
            
            
            //**************************  ИЗУЧИ ФУНКЦИЮ  convert ******************************
            /// ВОТ ТАК ПРОСТО Я ПОЛУЧАЮ ЦЕНТР КНОПОК В АБСОЛЮТНЫХ КООРДИНАТАХ
            /// И ЗАДАЮ ЭТО КАК ЦЕНТР РАЗВОРАЧИВАЮЩЕЙСЯ АНИМАЦИИ
            if( gotCenter != nil ) {
            
                let localCoordinatesInsideButton = self.selectedButton.convert(self.selectedButton.center, from: self.view)
                let finalPoint = CGPoint(x: gotCenter!.x + localCoordinatesInsideButton.x,
                                         y: gotCenter!.y + localCoordinatesInsideButton.y)
                
                transition.origin = finalPoint
            }
            
           
            
            
            controller.transitioningDelegate = transition    //MARK:  transitionDelegate - насколько я понял
                                                              //по умолчанию у въю-контролллера есть, и связывать его надо не с self
                                                              //а конкретно с Аниматор Менеджером
                                                              //no тут self - потому что сама въюха делегат
            controller.modalPresentationStyle = .custom
            
         
        }
    }
    
        

    
    
//    // Методы Transition Delegate ===============================
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .Present
//        transition.origin = selectedButton.center
//        transition.circleColor = selectedButton.backgroundColor!
//        return transition
//    }
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .Dismiss
//        transition.origin = selectedButton.center
//        transition.circleColor = selectedButton.backgroundColor!
//        return transition
//    }//==========================================================
 
    
    
   
    
    
    
    
}//--- end of class declaration ----
