//
//  ViewModelType.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/12.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
