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
    
//    private let useCase: StadiumUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let refreshButtonTapEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var cardList = PublishRelay<AroundMeResponse?>()
    }
    
    // MARK: - Initialize
    
//    init(useCase: StadiumUseCase) {
//        self.useCase = useCase
//    }
}

extension AroundMeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe{ owner, _ in
//            self.useCase.getStadiumList()
        }.disposed(by: self.disposeBag)
        
        input.refreshButtonTapEvent
            .withUnretained(self)
            .subscribe{ owner, _ in
//            self.useCase.getStadiumList()
        }.disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
//        let stadiumListRelay = useCase.stadiumList
//        let ingStadiumRelay = useCase.ingStadium
//
//        stadiumListRelay.subscribe { model in
//            output.stadiumLists.accept(model)
//        }.disposed(by: self.disposeBag)
//
//        ingStadiumRelay.subscribe { model in
//            output.ingStadium.accept(model)
//        }.disposed(by: self.disposeBag)
    }
}

