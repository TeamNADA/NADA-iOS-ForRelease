//
//  UIImageView+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/17.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    @discardableResult
    func updateServerImage(_ imagePath: String) -> Bool {
        guard let url = URL(string: imagePath) else {
            self.image = UIImage()
            return false
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.25)),
                .cacheOriginalImage
            ]) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print("kingfisher work failed: \(error.localizedDescription)")
            }
        }
        return true
    }
}
