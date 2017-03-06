//
//  iOS10BlurrerShadow.swift
//  iOS10ImageRenderer
//
//  Created by Pierre Perrin on 28/02/2017.
//  Copyright © 2017 Pierre Perrin. All rights reserved.
//

import UIKit
import CoreGraphics

class PPMusicImageShadow: UIView {
    
    override var contentMode: UIViewContentMode{
        set{
            super.contentMode = newValue
            
            self.imageView?.contentMode = newValue
            self.blurredImageView?.contentMode = newValue

        }get{
            return super.contentMode
        }
    }
    
    @IBInspectable var blurRadius : CGFloat = 10{
        didSet{
            self.calculateBlurredImage()
        }
    }
    
    func getNewImageSize() -> CGSize{
        
        var imageWidth : CGFloat
        var imageHeight : CGFloat
        
        if self.contentMode == .scaleAspectFit{
            
            let widthRatio = imageView.bounds.size.width / (imageView.image?.size.width)!;
            let heightRatio = imageView.bounds.size.height / (imageView.image?.size.height)!;
            let scale = min(widthRatio, heightRatio)
            imageWidth = scale * (imageView.image?.size.width)!;
            imageHeight = scale * (imageView.image?.size.height)!;
        }else{
            
            imageWidth = self.frame.size.width;
            imageHeight = self.frame.size.height;
        }
        
       
        
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    @IBInspectable var cornerRaduis : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            imageView!.layer.cornerRadius = newValue
            imageView!.layer.masksToBounds = true
            
        }
    }
    
    @IBInspectable  var image : UIImage?{
        set{
            self.imageView?.image = newValue
            self.calculateBlurredImage()
        }get{
            return self.imageView?.image
        }
    }
    
    var imageView : UIImageView!
    var blurredImageView : UIImageView!
    
    func calculateBlurredImage(){
        #if !TARGET_INTERFACE_BUILDER
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                
                if let imageToblur = self.image,
                    let resizedImage = imageToblur.resized(withPercentage: 0.3),
                    let ciimage = CIImage.init(image:resizedImage),
                    let blurredImage = self.applyBlur(ciimage: ciimage){
                    
                    DispatchQueue.main.async {
                        self.blurredImageView?.image = blurredImage
                    }
                }
            }
            
            
        #else
            self.blurredImageView?.image = self.image
        #endif
    }
    
    func applyBlur(ciimage : CIImage) -> UIImage?{
        
        let overlay = CIImage.init(color: CIColor(color: UIColor(white: 0.0, alpha: 0.3)))
        overlay.cropping(to: ciimage.extent)
        
        
        if let filter = CIFilter(name: "CIGaussianBlur") {
            
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            filter.setValue(blurRadius, forKey: kCIInputRadiusKey)
            let context = CIContext(options: nil)
            if let output = filter.outputImage,
                let cgimg = context.createCGImage(output, from: ciimage.extent)
            {
                
                return UIImage(cgImage: cgimg)
            }
        }
        
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = self.bounds
        var newBounds = CGRect.zero
        
        let imageSize = getNewImageSize()
        
        let addWidth :CGFloat = imageSize.width * 0.3
        let addHeigth :CGFloat = imageSize.height * 0.3
        
        let newWidth = imageSize.width + addWidth
        let newHeight = imageSize.height + addHeigth
        newBounds.size.width = newWidth
        newBounds.size.height = newHeight
        newBounds.origin.y = 0
        
        self.blurredImageView?.frame = newBounds
        self.blurredImageView?.center = self.imageView.center
        self.blurredImageView?.center.y = self.imageView.center.y + imageSize.height * 0.06
        
        let mask = CALayer()
        mask.contents = UIImage.init(named: "shadowMask")?.cgImage
        mask.frame =  self.blurredImageView!.bounds
        self.blurredImageView?.layer.mask = mask
        self.blurredImageView?.layer.masksToBounds = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addShadow()
    }
    
    init(image: UIImage?) {
        var frame = CGRect.zero
        if let imageSet = image{
            frame = CGRect.init(x: 0, y: 0, width: imageSet.size.width, height: imageSet.size.height)
        }
        super.init(frame:frame)
        
        self.addShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addShadow()
    }
    
    
    func addShadow(){
        
        imageView = UIImageView()
        blurredImageView = UIImageView()
        self.calculateBlurredImage()
        self.addSubview(blurredImageView!)
        self.addSubview(imageView!)
        self.imageView?.contentMode = self.contentMode
        self.blurredImageView?.contentMode = self.contentMode
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
