//
//  RevealViewController.swift
//  SlideBar
//
//  Created by 김나희 on 10/6/22.
//

import UIKit

class RevealViewController: UIViewController {
    var contentVC: UIViewController?
    var sideVC: UIViewController?
    var isSideBarShowing = false
    let SLIDE_TIME = 0.3
    let SIDEBAR_WIDTH: CGFloat = 260
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // 초기 화면 설정
    private func setupView() {
        // FrontViewController를 불러옴
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "front") as? UINavigationController {
            self.contentVC = vc // 콘텐츠를 담당할 뷰 컨트롤러로 설정
            self.addChild(vc) // RevealViewController의 자식으로 등록
            self.view.addSubview(vc.view) // 뷰도 따로 등록해주어야함. vc와 view 계층 분리되어있기 때문
            vc.didMove(toParent: self) // 부모 VC가 변경되었음을 알려준다.
            
            // 내비게이션 컨트롤러의 루트 뷰 컨트롤러
            let frontVC = vc.viewControllers[0] as? FrontViewController
            frontVC?.sideBarDelegate = self
        }
        
    }
    
    // 사이드 바
    private func setupSideBar() {
        guard sideVC == nil,
              let vc = storyboard?.instantiateViewController(withIdentifier: "sidebar") else {
            return
        }
        
        self.sideVC = vc
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        self.view.bringSubviewToFront((self.contentVC?.view)!)
        
    }
    
    // 그림자 효과
    private func setupShadowEffect(shadow: Bool, offset: CGFloat) {
      if (shadow == true) {
        self.contentVC?.view.layer.cornerRadius = 10
        self.contentVC?.view.layer.shadowOpacity = 0.8
        self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor
        self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset)
      } else {
        self.contentVC?.view.layer.cornerRadius = 0
        self.contentVC?.view.layer.shadowOffset = CGSize(width:0, height:0)
      }
    }
    
    
    // 사이드바 open
    func openSideBar(_ complete: (() -> Void)?) {
        setupSideBar()
        setupShadowEffect(shadow: true, offset: -2)
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        UIView.animate(
            withDuration: TimeInterval(SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                self.contentVC?.view.frame = CGRect(x: self.SIDEBAR_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 == true {
                    self.isSideBarShowing = true
                    complete?()
                }
            }
        )
    }
    
    // 사이드바 close
    func closeSideBar(_ complete: (() -> Void)?) {
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        UIView.animate(
            withDuration: TimeInterval(SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 == true {
                    self.sideVC?.view.removeFromSuperview()
                    self.sideVC = nil
                    self.isSideBarShowing = false
                    self.setupShadowEffect(shadow: false, offset: 0)
                    complete?()
                }
            }
        )
    }
}

