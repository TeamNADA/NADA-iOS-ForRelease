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
    
    private let disposeBag = DisposeBag()
    var groupList: [Group] = []
    
    // MARK: - Inputs
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var groupListRelay = PublishRelay<[Group]>()
    }
    
    // MARK: - Initialize
    
    init(groupList: [Group]) {
        self.groupList = groupList
    }
}

extension GroupEditViewModel {
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { owner, _ in
                output.groupListRelay.accept(owner.groupList)
                print("✅✅", owner.groupList)
            }
            .disposed(by: self.disposeBag)
        
        return output
    }
}
