//
//  GroupViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import UIKit

class GroupViewController: UIViewController {

    static var newInstance: GroupViewController {
        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "GroupViewController"
        ) as! GroupViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
