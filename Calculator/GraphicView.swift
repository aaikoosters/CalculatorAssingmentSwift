//
//  GraphView.swift
//  Calculator
//
//  Created by AaikOosters on 31-12-15.
//  Copyright © 2015 Aaik Oosters. All rights reserved.
//

import UIKit

class GraphicView: UIView
{
    var axes = AxesDrawer()
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        axes.contentScaleFactor = self.contentScaleFactor;
        axes.drawAxesInRect(self.bounds, origin: self.center, pointsPerUnit: 50)
    }
}
