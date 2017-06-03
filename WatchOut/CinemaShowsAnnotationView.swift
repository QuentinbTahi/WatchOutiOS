//
//  CinemaShowsAnnotationView.swift
//  AZCustomCallout
//
//  Created by Alexander Andronov on 23/06/16.
//  Copyright © 2016 Alexander Andronov. All rights reserved.
//

import Foundation
import MapKit

class CinemaShowsAnnotationView : MKPinAnnotationView {
    fileprivate var calloutView: CinemaHoursCallout?
    
    var theaterShowTime:WOTheaterShowtime!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let calloutViewAdded = calloutView?.superview != nil
        
            super.setSelected(selected, animated: animated)
        
        self.superview?.bringSubview(toFront: self)
        
        if (calloutView == nil) {
            calloutView = UINib(nibName: "CinemaHoursCallout", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CinemaHoursCallout
            calloutView?.theaterShowTime = theaterShowTime
        }
        
        if (self.isSelected && !calloutViewAdded) {
            let width = 230.0
            let height = 300.0
            let calloutHeightOffset = 5.0
            let halfSelfWidth = Double(frame.size.width/2.0)
            let halfWidth = -width/2.0
            let x = halfSelfWidth+halfWidth
            let calloutWidthOffset = 5.0 //depends on pin width
            calloutView!.frame = CGRect(origin: CGPoint(x: x - calloutWidthOffset, y: -height-calloutHeightOffset), size: CGSize(width: width, height: height))
            calloutView!.style()
            
            addSubview(calloutView!)
            bringSubview(toFront: calloutView!)
        }
        
        if (!self.isSelected) {
            calloutView?.removeFromSuperview()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        
        if hitView == nil && self.isSelected {
            let pointInCallout = convert(point, to: calloutView)
            hitView = calloutView!.hitTest(pointInCallout, with: event)
        }
        
        if let callout = calloutView {
            if (hitView == nil && self.isSelected) {
                hitView = callout.hitTest(point, with: event)
            }
        }
        
        return hitView;
    }
}
