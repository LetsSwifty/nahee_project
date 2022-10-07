//
//  FrontViewController.swift
//  SlideBar
//
//  Created by 김나희 on 10/6/22.
//

import UIKit

class FrontViewController: UIViewController {
    var sideBarDelegate: RevealViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    
        let sideBarButton = UIBarButtonItem(image: UIImage(named: "sidemenu"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(configureSideBar))
        navigationItem.title = "첫화면"
        navigationItem.leftBarButtonItem = sideBarButton
        
        // 뷰에 제스처 객체 등록
        
        // 패닝(화면의 한쪽 끝에서 반대편으로 드래그 패턴) -> UIScreenEdgePanGestureRecognizer
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self,
                                                        action: #selector(configureSideBar))
        dragLeft.edges = .left // 시작 모서리
        view.addGestureRecognizer(dragLeft)
        
        // 스와이프 (중간 위치에서 드래그 패턴) -> UISwipeGestureRecognizer
        let dragRight = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(configureSideBar))
        dragRight.direction = .left // 제스처 방향
        view.addGestureRecognizer(dragRight)
        
    }
    
    // 사용자의 액션에 따라 델리게이트 메소드를 호출
    @objc
    func configureSideBar(_ sender: Any) {
        if sender is UIScreenEdgePanGestureRecognizer {
            self.sideBarDelegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.sideBarDelegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem { // 버
            if self.sideBarDelegate?.isSideBarShowing == false {
                self.sideBarDelegate?.openSideBar(nil)
            } else {
                self.sideBarDelegate?.closeSideBar(nil)
            }
        }
    }
}
