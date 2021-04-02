//
//  HomeTaBarViewController.swift
//  SwiftProject
//
//  Created by Miles on 2021/3/29.
//

import UIKit

class HomeTaBarViewController: UITabBarController {
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1,4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = .cubic
        return bounceAnimation
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        tabBar.backgroundColor = UIColor.lightGray
        tabBar.tintColor = UIColor(red: 255/255, green: 78/255, blue: 80/255, alpha: 1)
        setupChildVC()
    }
    
    private func setupChildVC() {
        let first = ExampleTableViewController()
        setTabbarChild(first, title: "首页", img: "tabBar_home_normal", selectImg: "tabBar_home_selected")
        setTabbarChild(first, title: "通话", img: "tabBar_call_normal", selectImg: "tabBar_call_selected")
        setTabbarChild(first, title: "联系人", img: "tabBar_link_normal", selectImg: "tabBar_link_selected")
        setTabbarChild(first, title: "消息", img: "tabBar_message_normal", selectImg: "tabBar_message_selected")
    }
    
    private func setTabbarChild(_ vc: UIViewController, title: String, img: String, selectImg: String) {
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        
        var image = UIImage(named: img)
        image = image?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.image = image
        
        var selectImage = UIImage(named: selectImg)
        selectImage = selectImage?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = selectImage
        
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: -1.5, left: 0, bottom: 1.5, right: 0)
        addChild(nav)
        
    }
        
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        /**
         find index if the selected tab bar item, then find the corresponding view and get its image
        the view position is offset by 1 because the first item is the background (at least in this case)
        */
        guard let idx = tabBar.items?.firstIndex(of: item),
              tabBar.subviews.count > idx + 1,
              let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView}).first
              else { return }
        imageView.layer.add(bounceAnimation, forKey: nil)
        
        if idx == 0 {
            item.showBadge(style: .new, value: 1, animType: .bounce)
        }
        if idx == 1 {
            item.showBadge(style: .number, value: 99, animType: .breathe)
        }
        if idx == 2 {
            item.showBadge(style: .reddot, value: 98, animType: .scale)
        }
        if idx == 3 {
            item.showBadge(style: .new, value: 77, animType: .shake)
        }
    }
}

extension HomeTaBarViewController: UITabBarControllerDelegate {
    
}
