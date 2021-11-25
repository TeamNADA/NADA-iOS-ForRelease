//
//  CardCreationPreviewViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/21.
//

import UIKit

class CardCreationPreviewViewController: UIViewController {

    var backgroundImage: Data?
    var frontCardDataModel: FrontCardDataModel?
    var backCardDataModel: BackCardDataModel?
    
    private var cardCreationRequest: CardCreationRequest?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    @IBAction func touchCompleteButton(_ sender: Any) {
        guard let frontCardDataModel = frontCardDataModel, let backCardDataModel = backCardDataModel else { return }
        cardCreationRequest = CardCreationRequest(userID: "", frontCard: frontCardDataModel, backCard: backCardDataModel)
        guard let cardCreationRequest = cardCreationRequest else { return }
        cardCreationWithAPI(request: cardCreationRequest, image: UIImage(systemName: "circle")!)
    }
    @IBAction func touchBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension CardCreationPreviewViewController {
    private func setUI() {
        navigationController?.navigationBar.isHidden = true
        
        noticeLabel.font = .textRegular04
        noticeLabel.textColor = .primary
        
        setFrontCardWith()
        
    }
    
    private func setFrontCardWith() {
//        guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
        
        // FIXME: - @IBDesignables err
        guard let frontCard = Bundle(for: FrontCardCell.self).loadNibNamed("FrontCardCell", owner: self, options: nil)?.first as? FrontCardCell else { return }
        
        frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)

        guard let frontCardDataModel = frontCardDataModel else { return }
//        frontCard.initCell("\(frontCardDataModel.defaultImage)", frontCardDataModel.title, frontCardDataModel.description, frontCardDataModel.name, frontCardDataModel.birthDate, frontCardDataModel.mbti, frontCardDataModel.instagramID, frontCardDataModel.linkURL)
        
        // FIXME: - dummy data
        frontCard.initCell("card", "nada", "NADA의 짱귀염둥이 ㅎ 막이래~", "개빡쳐하는 오야옹~", "1999/05/12", "ENFP", "yaeoni", "github.com/yaeoni")
        cardView.addSubview(frontCard)
    }
    
    private func setBackCardWith() {
        guard let backCard = BackCardCell.nib().instantiate(withOwner: self, options: nil).first as? BackCardCell else { return }
        guard let backCardDataModel = backCardDataModel else { return }
        backCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
    }

    // MARK: - Network
    
    func cardCreationWithAPI(request: CardCreationRequest, image: UIImage) {
        CardAPI.shared.cardCreation(request: request, image: image) { response in
            switch response {
            case .success:
                print("cardCreationWithAPI - success")
            case .requestErr(let message):
                print("cardCreationWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardCreationWithAPI - pathErr")
            case .serverErr:
                print("cardCreationWithAPI - serverErr")
            case .networkFail:
                print("cardCreationWithAPI - networkFail")
            }
        }
    }
    
}
