//
//  ProgramingExampleViewController.swift
//  PPMusicImageShadow
//
//  Created by Pierre Perrin on 06/03/2017.
//  Copyright © 2017 Pierre Perrin. All rights reserved.
//

import UIKit

class ProgramingExampleViewController: UIViewController {

    var exampleView : PPMusicImageShadow!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addEffectView()
        self.prepareExampleView()
        self.setImageToExampleView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.exampleView.center = self.view.center
    }
    
    //MARK: Example
    func addEffectView(){
        
        self.exampleView = PPMusicImageShadow(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300))
        self.view.addSubview(self.exampleView)
    }
    
    func setImageToExampleView(){
        
        let image = UIImage(named: "prairie-679016_1920.jpg")
        self.exampleView.image = image
    }
    
    func prepareExampleView(){
        
        self.exampleView.cornerRaduis = 10
        self.exampleView.blurRadius = 5
    }

    
    
    // MARK: - Navigation
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
