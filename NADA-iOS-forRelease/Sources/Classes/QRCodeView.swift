//
//  QRCodeView.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/26.
//

import Foundation
import UIKit

class QRCodeView: UIView {

    // ✅ CIQRCodeGenerator : QR code 생성 필터를 식별하기 위한 속성.
    var filter = CIFilter(name: "CIQRCodeGenerator")

    // ✅ QRCode CIImage 를 만들어서 추가할 UIImageView.
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    // ✅ QRCode 이미지를 만들 때 다양한 색으로 만들 수 있도록 parameter 를 받았다.
    func generateCode(_ string: String, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        
        // ✅ 주어진 인코딩을(=using) 사용해서 NSData 개체를 반환한다.
        guard let filter = filter, let data = string.data(using: .isoLatin1, allowLossyConversion: false) else {
            return
        }
        
        // ✅ 두가지 파라미터 설정.
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")

        // ✅ .outputImage : 필터에 구성된 작업을 캡슐화하는 CIImage 개체이다. 즉, 결과물
        guard let ciImage = filter.outputImage else {
            return
        }

        // ❗️ 이렇게 끝내면 qr code 가 선명하지 않게 나온다.
        //imageView.image = UIImage(ciImage: ciImage, scale: 2.0, orientation: .up)
        
        // ✅ 다음은 이미지 선명하게 변환하는 과정이다.
        // ✅ 원래 이미지에 affine transform(by 파라미터를 의미.) 을 적용한 새 이미지를 반환. 이미지의 넓이와 높이를 10배 증가시킴.
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        
        // ✅ 다음은 QR code 색 커스텀 설정하는 과정이다. 필터 생성하고 이미지 적용.
        // ✅ CIColorInvert : 색상을 반전시키기 위한 필터이다.
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)

        // ✅ CIMaskToAlpha : grayscale 로 변환된 이미지를 alpha 로 마스킹된 흰색이미지로 변환.
        let alphaFilter = CIFilter(name: "CIMaskToAlpha")
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        
        // ✅ 받은 파라미터로 imageView 의 속성을 설정.
        if let ouputImage = alphaFilter?.outputImage {
            imageView.tintColor = foregroundColor
            imageView.backgroundColor = backgroundColor

            // ✅ withRenderingMode(.alwaysTemplate) : 원본 이미지의 컬러정보가 사라지고 불투명한 부분을 tintColor 로 설정.
            imageView.image = UIImage(ciImage: ouputImage, scale: 2.0, orientation: .up).withRenderingMode(.alwaysTemplate)
        } else {
            return
        }
    }
}
