//
//  BottomStackItem.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import Foundation

class BottomStackItem {
    
    var tabImage: String
    var isSelected: Bool
    
    init(tabImage: String,
         isSelected: Bool = false) {
        self.tabImage = tabImage
        self.isSelected = isSelected
    }
}
