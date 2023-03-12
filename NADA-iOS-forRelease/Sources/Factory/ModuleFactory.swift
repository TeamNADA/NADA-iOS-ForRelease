//
//  ModuleFactory.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/12.
//

import UIKit

/*
 - 사용법:
 1) ModuelFactoryProtocol에 넘겨야할 VC를 메서드 형태로 정의만 한다.
 
 2) ModuleFactory를 extension해서 구현해야 할 부분을 직접 작성한다.
 controllerFromStoryboard(익스텐션)를 활용해서 인스턴스를 생성한다
 -> storyboard를 사용하지 않으면 가져오지 않고 뷰컨 자체를 가지고 오면 된다.
 
 3) 각각 필요한 VC내에서 MoudleFactory를 가지고 뷰컨을 가져오면 끝!
 
 @creds to Song jihun (github: https://github.com/i-colours-u)
 */

protocol ModuleFactoryProtocol {
    func makeSplashVC() -> SplashViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    static let shared = ModuleFactory()
    private init() { }
    
    func makeSplashVC() -> SplashViewController {
        let splashVC = SplashViewController.controllerFromStoryboard(.splash)
        return splashVC
    }
}
