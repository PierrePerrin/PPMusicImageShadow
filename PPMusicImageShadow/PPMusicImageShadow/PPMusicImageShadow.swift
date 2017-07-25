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
    
    @IBInspectable var blurRadius : CGFloat = 3{
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
            imageView!.layer.masksToBounds = false
            
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
    
    var resizeConstant :CGFloat = 0.2
    
    var imageView : UIImageView!
    var blurredImageView : UIImageView!
    var blurWork : DispatchWorkItem?
    
    func calculateBlurredImage(){
        
        
        #if !TARGET_INTERFACE_BUILDER
            blurWork?.cancel()
            blurWork = DispatchWorkItem(qos: DispatchQoS.userInteractive, flags: DispatchWorkItemFlags.noQoS) {
                
                if let imageToblur = self.image{
                    
                    let containerLayer = CALayer()
                    containerLayer.frame = CGRect(origin: .zero, size: self.getNewImageSize().scaled(by: 1.4))
                    containerLayer.backgroundColor = UIColor.clear.cgColor
                    let blurImageLayer = CALayer()
                    blurImageLayer.frame = CGRect(origin: CGPoint.init(x: self.getNewImageSize().width * self.resizeConstant, y: self.getNewImageSize().height * self.resizeConstant), size: self.getNewImageSize())
                    blurImageLayer.contents = imageToblur.cgImage
                    blurImageLayer.cornerRadius = self.cornerRaduis
                    blurImageLayer.masksToBounds = false
                    containerLayer.addSublayer(blurImageLayer)
                    
                    var containerImage = UIImage()
                    // Get the UIImage from a UIView.
                    if containerLayer.frame.size != CGSize.zero {
                        containerImage = UIImage(layer: containerLayer)
                    }else {
                        containerImage = UIImage()
                    }
                    
                    guard
                        let resizedImage = containerImage.resized(withPercentage: self.resizeConstant),
                        let ciimage = CIImage.init(image:resizedImage),
                        let blurredImage = self.applyBlur(ciimage: ciimage) else {return}
                    
                    DispatchQueue.main.async {
                        self.blurredImageView?.image = blurredImage
                    }
                }
            }
            blurWork?.perform()
            
        #else
            self.blurredImageView?.image = self.image
        #endif
    }
    
    @IBInspectable
    public var shadowOffSet: CGSize = CGSize.init(width: 0, height: 0){
        didSet{
            self.layoutSubviews()
        }
    }
    
    @IBInspectable
    public var shadowSizeConstant: CGFloat = 1.5{
        didSet{
            self.layoutSubviews()
        }
    }
    
    func applyBlur(ciimage : CIImage) -> UIImage?{
        
        let overlay = CIImage.init(color: CIColor(color: UIColor(white: 0.0, alpha: 0.3)))
        overlay.cropping(to: ciimage.extent)
        
        if let filter = CIFilter(name: "CIGaussianBlur") {
            
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            filter.setValue(blurRadius, forKey: kCIInputRadiusKey)
            let eaglContext =
                EAGLContext(api: EAGLRenderingAPI.openGLES3)
                    ??  EAGLContext(api: EAGLRenderingAPI.openGLES2)
                    ??  EAGLContext(api: EAGLRenderingAPI.openGLES1)
            
            let context = eaglContext == nil ?
                CIContext.init(options: nil)
                : CIContext.init(eaglContext: eaglContext!)
            
            if let output = filter.outputImage,
                let cgimg = context.createCGImage(output, from: ciimage.extent)
            {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return nil
    }
    
    var imageSize : CGRect!{
        var newBounds = CGRect.zero
        let imageSize = getNewImageSize()
        
        let addWidth :CGFloat = imageSize.width * 1.2
        let addHeigth :CGFloat = imageSize.height * 1.2
        
        let newWidth = imageSize.width + addWidth
        let newHeight = imageSize.height + addHeigth
        newBounds.size.width = newWidth
        newBounds.size.height = newHeight
        return newBounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = self.bounds
        
        self.blurredImageView?.frame = self.bounds
        self.blurredImageView?.frame.size = getNewImageSize().scaled(by: shadowSizeConstant)
        
        self.blurredImageView?.center.x = self.imageView.center.x + shadowOffSet.width
        self.blurredImageView?.center.y = self.imageView.center.y + shadowOffSet.height
        self.blurredImageView.contentMode = .scaleAspectFit
        
        let mask = CALayer()
        let imageName = "PPMusicImageShadowMask"
        let image = UIImage.init(named: imageName, in:Bundle.init(identifier: "PPMusicImageShadow") ?? Bundle.init(for: self.classForCoder), compatibleWith: nil) ??  UIImage.init(named: imageName)
        mask.contents =  image?.cgImage
        mask.frame =  self.blurredImageView!.bounds
        //self.blurredImageView?.layer.mask = mask
        self.blurredImageView?.layer.masksToBounds = false
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
        self.addSubview(blurredImageView!)
        self.addSubview(imageView!)
        self.imageView?.contentMode = self.contentMode
        self.blurredImageView?.contentMode = self.contentMode
        self.calculateBlurredImage()
    }
}
