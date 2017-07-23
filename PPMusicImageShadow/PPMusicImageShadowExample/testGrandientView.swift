//
//  testGrandientView.swift
//  PPMusicImageShadow
//
//  Created by Pierre Perrin on 05/04/2017.
//  Copyright © 2017 Pierre Perrin. All rights reserved.
//

import UIKit

class TestGradient : UIView
{
    override func layoutSubviews() {
        super.layoutSubviews()
        let topLayer = CAGradientLayer()
        topLayer.colors = [ UIColor.clear.cgColor,UIColor.black.cgColor]
        //topLayer.startPoint = CGPoint.init(x: 0, y:0)
        topLayer.locations = [0,0.1,0.2,1.0]
       // topLayer.endPoint = CGPoint.init(x: 0, y: 0.1)
        topLayer.frame = self.bounds
        
        let downLayer = CAGradientLayer()
        downLayer.colors = [ UIColor.black.cgColor,UIColor.clear.cgColor]
        downLayer.startPoint = CGPoint.init(x: 0, y:0.9)
        downLayer.endPoint = CGPoint.init(x: 0, y: 1)
        downLayer.frame = self.bounds
        
        //topLayer.mask = downLayer
        if self.layer.mask == nil
            self.layer.mask = topLayer
        }
    }
}
