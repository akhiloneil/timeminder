//
//  BounceButton.swift
//  Time Keeper
//
//  Created by Akhil Sharma on 7/13/17.
//  Copyright © 2017 Akhil Sharma. All rights reserved.
//

import UIKit

class BounceButton: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        
        
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 7, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
        super.touchesBegan(touches, with: event)
    }
    
    
}
