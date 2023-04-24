//
//  CardCreationCategoryViewModel.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/02/22.
//

import Foundation

import RxCocoa
import RxSwift

struct CardCreationCategoryViewModel: ViewModelType {
    struct Input {
        let touchBasic: ControlEvent<UITapGestureRecognizer>
        let touchcompany: ControlEvent<UITapGestureRecognizer>
        let touchfan: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let touchBasic: ControlEvent<UITapGestureRecognizer>
        let touchcompany: ControlEvent<UITapGestureRecognizer>
        let touchfan: ControlEvent<UITapGestureRecognizer>
    }
    
    func transform(input: Input) -> Output {
        return Output(touchBasic: input.touchBasic,
                      touchcompany: input.touchcompany,
                      touchfan: input.touchfan)
    }
}
