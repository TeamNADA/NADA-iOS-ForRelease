//
//  AroundMeViewModel.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/12.
//

import RxSwift
import RxRelay

final class AroundMeViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private var cardList: [AroundMeResponse] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let refreshButtonTapEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var cardList = PublishRelay<[AroundMeResponse]>()
        var error = PublishRelay<Error>()
    }
    
    // MARK: - Initialize
    
//    init(useCase: StadiumUseCase) {
//        self.useCase = useCase
//    }
}

extension AroundMeViewModel {
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { owner, _ in
//            self.useCase.getStadiumList()
                // get 서버통신
            output.cardList.accept(owner.cardList)
        }.disposed(by: self.disposeBag)
        
        input.refreshButtonTapEvent
            .withUnretained(self)
            .subscribe { owner, _ in
//            self.useCase.getStadiumList()
                // get 서버통신
            
            output.cardList.accept(owner.cardList)
        }.disposed(by: self.disposeBag)
        
        return output
    }
}
