//
//  Header.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/17.
//

import Foundation

extension Const {
    
    struct Header {
        static var bearerHeader = ["Authorization": "Bearer " + headerToken]
        
        static var basicHeader = ["Content-Type": "application/json",
                                  "Authorization": "Bearer " + headerToken]
    }
}
