//
//  StackItemView.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import UIKit

protocol StackItemViewDelegate: AnyObject {
    func handleTap(_ view: StackItemView)
}

class StackItemView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectView: UIView!
    
    static var newInstance: StackItemView {
        return Bundle.main.loadNibNamed(
            StackItemView.className(),
            owner: nil,
            options: nil
        )?.first as! StackItemView
    }
    
    weak var delegate: StackItemViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture()
    }
    
    var isSelected: Bool = false {
        willSet {
            self.updateUI(isSelected: newValue)
        }
    }
    
    var item: Any? {
        didSet {
            self.configure(self.item)
        }
    }
    
    private func configure(_ item: Any?) {
        guard let model = item as? BottomStackItem else { return }
        self.imageView.image = UIImage(named: model.tabImage)
        self.isSelected = model.isSelected
    }
    
    private func updateUI(isSelected: Bool) {
        guard let model = item as? BottomStackItem else { return }
        model.isSelected = isSelected
        let options: UIView.AnimationOptions = isSelected ? [.curveEaseIn] : [.curveEaseOut]
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.5,
                       options: options,
                       animations: {
            (self.superview as? UIStackView)?.layoutIfNeeded()
        }, completion: nil)
    }
}

extension StackItemView {
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.handleTap(self)
    }
    
}
