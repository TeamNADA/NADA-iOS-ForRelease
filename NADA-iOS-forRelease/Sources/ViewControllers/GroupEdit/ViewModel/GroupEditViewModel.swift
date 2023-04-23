//
//  GroupEditViewModel.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/04/23.
//

import RxSwift
import RxRelay

final class GroupEditViewModel: ViewModelType {
    
    // MARK: - Properties
    
//    private let useCase: StadiumUseCase
    private let disposeBag = DisposeBag()
    private var groupList: [Group] = []
    
    // MARK: - Inputs
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var groupList = PublishRelay<[Group]>()
        var error = PublishRelay<Error>()
    }
    
    // MARK: - Initialize
    
    init(groupList: [Group]) {
        self.groupList = groupList
    }
}

extension GroupEditViewModel {
    func transform(input: Input) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { owner, _ in
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
