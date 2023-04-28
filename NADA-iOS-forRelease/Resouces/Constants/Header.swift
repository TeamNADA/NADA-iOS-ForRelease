//
//  Header.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/17.
//

import Foundation

extension Const {
    
    struct Header {
        static func applicationJsonHeader() -> [String: String] {
            ["Content-Type": "application/json"]
        }
        
        static func multipartFormHeader() -> [String: String] {
            ["Content-Type": "application/json",
             "Authorization": "Bearer \(UserDefaults.appGroup.string(forKey: Const.UserDefaultsKey.accessToken) ?? "")"]
        }
        
        static func bearerHeader() -> [String: String] {
            ["Authorization": "Bearer \(UserDefaults.appGroup.string(forKey: Const.UserDefaultsKey.accessToken) ?? "")"]
        }
        
        static func basicHeader() -> [String: String] {
            ["Content-Type": "application/json",
             "Authorization": "Bearer \(UserDefaults.appGroup.string(forKey: Const.UserDefaultsKey.accessToken) ?? "")"]
        }
    }
}
