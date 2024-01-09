//
//  SplashViewController.swift
//  CCommerce
//
//  Created by 이정동 on 1/6/24.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    @IBOutlet weak var appicon: UIImageView!
    @IBOutlet weak var appiconCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var appiconCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.uiViewAnimation()
        self.lottieAnimation()
    }

    private func uiViewAnimation() {
        appiconCenterXConstraint.constant = -(view.frame.width / 2) - (appicon.frame.width / 2)
        appiconCenterYConstraint.constant = -(view.frame.height / 2) - (appicon.frame.height / 2)
        
        /*
         변경된 Frame(위치, 크기) View의 Drawing LifeCycle 동안 기다리지 않고,
         layoutIfNeeded()를 호출하여 View를(2초 동안) 즉시 업데이트 하라고 요청
         */
        UIView.animate(withDuration: 2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        /*
         Frame을 변경하는 것이 아니기 때문에
         animations 클로저 내부에 애니메이션(아이콘 회전) 구현 및 layoutIfNeeded() 호출 X
         */
        UIView.animate(withDuration: 2) { [weak self] in
            let rotatingAngle = CGFloat.pi
            self?.appicon.transform = CGAffineTransform(rotationAngle: rotatingAngle)
        }
    }
    
    private func lottieAnimation() {
        lottieAnimationView.play { _ in
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = viewController
            }
        }
    }
}
