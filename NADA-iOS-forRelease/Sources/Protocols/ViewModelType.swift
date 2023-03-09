//
//  ViewModelType.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/03/08.
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
