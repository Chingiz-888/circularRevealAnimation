//===== PopAnimator.swift====================================================


// PopAnimator.swift
// PopTransitionAnimation

import UIKit





class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    
    
    enum PopTransitionMode : Int {
        case Present, Dismiss
    }
    
    var transitionMode: PopTransitionMode = .Present
    
    // View of circle being presented
    var circle: UIView?
    
    // Color of circle, set based on button clicked
    var circleColor: UIColor?
    
    // Starting point of transition
    var origin  : CGPoint? //CGPoint.zero                  // <<< ВОТ ЭТА ПЕРЕМЕННАЯ ЗАДАЕТ ЦЕНТР РАЗВОРОТА ЭКРАНА
    
    
    //Duration
    var presentDuration = 4.5
    var dismissDuration = 1.3
    
    func transitionDuration( using transitionContext: UIViewControllerContextTransitioning? ) -> TimeInterval {
        // Set transition duration based on whether it is a presenting or dismissing transition
        if transitionMode == .Present {
            return presentDuration
        }
        else {
            return dismissDuration
        }
    }
    
    
    // Return the frame for the circle required to fill the screen
    func frameForCircle( center: CGPoint, size: CGSize, start: CGPoint ) -> CGRect {
        
        //***************  ПОНЯТЬ ЧТО ТУТ ЗА АЛГОРИТМ ТАКОЙ КАКОЕ ОТНОШЕНИ ОНА ИМЕЕТ К ПИФАГОРУ **********
        let lengthX = fmax  ( start.x, size.width  - start.x )
        let lengthY = fmax  ( start.y, size.height - start.y )
        let offset  = sqrt  ( lengthX * lengthX +  lengthY * lengthY  ) * 2
        let size    = CGSize( width: offset, height: offset )
        //************************************************************************************************
        
        //CGPointZero - это поди наименование-хелпер для 1.0, 1.0 точки
        //верхней левой
        return CGRect(origin: CGPoint.zero,
                      size  : size)
    }
    
    //MARK: the most important method ------------------------------------------------
    func animateTransition( using transitionContext: UIViewControllerContextTransitioning ) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .Present {     /*** ПРЯМАЯ АНИМАЦИЯ - АНИМАЦИЯ ПЕРЕХОДА ***/
            
            // Get view of view controller being presented
            let presentedView          = transitionContext.view( forKey: UITransitionContextViewKey.to )
            let originalCenter         = presentedView?.center
            let originalSize           = presentedView?.frame.size
            
            // Get frame of circle
            circle                     = UIView( frame: frameForCircle( center: originalCenter!,
                                                                        size  : originalSize!,
                                                                        start : origin! ) )
            circle?.layer.cornerRadius = circle!.frame.size.height / 2
            circle!.center             = origin!
            
            // Make it very small
            circle!.transform          = CGAffineTransform( scaleX: 0.001, y: 0.001 )
            
            // Set the background color
            circle!.backgroundColor    = circleColor
            
            // Add circle to container view
            containerView.addSubview( circle! )
            
            // Make presented view very small and transparent
            presentedView?.center    = origin!
            presentedView?.transform = CGAffineTransform( scaleX: 0.001, y: 0.001 )
            
            // Set the background color
            presentedView?.backgroundColor = circleColor
            
            // Add presented view to container view
            containerView.addSubview( presentedView! )
            
            // Animate both views
            UIView.animate( withDuration: presentDuration,
                            animations: {
                                            self.circle!.transform    = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                            presentedView?.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                            presentedView?.center     = originalCenter!
                                        }
                           ) {  (_) -> Void in
                                            // On completion, complete the transition
                                            transitionContext.completeTransition(true)
                             }
        }
        else                                /*** ОБРАТНАЯ АНИМАЦИЯ - АНИМАЦИЯ ВОЗВРАТА ***/
        {
            // Essentially doind the same thing, but in reverse
            let returningControllerView = transitionContext.view( forKey: UITransitionContextViewKey.from )
            let originalCenter          = returningControllerView?.center
            let originalSize            = returningControllerView?.frame.size
            
            circle!.frame               = frameForCircle( center: originalCenter!, size: originalSize!, start: origin! )
            circle?.layer.cornerRadius  = circle!.frame.size.height / 2
            circle!.center              = origin!
            
            UIView.animate( withDuration: dismissDuration, animations: {
                self.circle!.transform             = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView?.center = self.origin!
                returningControllerView?.alpha     = 0
            }) {  (_) -> Void in 
                returningControllerView?.removeFromSuperview()
                self.circle!.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }//end of animateTransition fucntion
    
  
    
    
    // Методы Transition Delegate ===============================
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // если мы не задали origin, то по умолчанию он центр экрана
        if( self.origin == nil ) {
             self.origin         = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        }
  
        self.transitionMode = .Present
        self.circleColor    = UIColor(colorLiteralRed: 234/255.0, green: 234/255.0, blue: 23/255.0, alpha: 0.8)
        
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
         // если мы не задали origin, то по умолчанию он центр экрана
        if( self.origin == nil ) {
            self.origin         = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        }
        
        self.transitionMode = .Dismiss
        self.circleColor    = UIColor(colorLiteralRed: 24/255.0, green: 134/255.0, blue: 23/255.0, alpha: 0.8)
        return self
    }//==========================================================
    
    
    
    
}// end of class declaration -----
