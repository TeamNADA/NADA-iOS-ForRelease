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
        let touchJob: ControlEvent<UITapGestureRecognizer>
        let touchDigging: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let touchBasic: ControlEvent<UITapGestureRecognizer>
        let touchJob: ControlEvent<UITapGestureRecognizer>
        let touchDigging: ControlEvent<UITapGestureRecognizer>
    }
    
    func transform(input: Input) -> Output {
        return Output(touchBasic: input.touchBasic,
                      touchJob: input.touchJob,
                      touchDigging: input.touchDigging)
    }
}
