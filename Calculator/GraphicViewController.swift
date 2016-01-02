//
//  GraphicViewController.swift
//  Calculator
//
//  Created by Aaik Oosters on 31-12-15.
//  Copyright © 2015 Aaik Oosters. All rights reserved.
//

import UIKit

class GraphicViewController: UIViewController
{
    @IBOutlet weak var label: UILabel!
    
    var brain = CalculatorBrain?()
    
    @IBOutlet weak var graphicView: GraphicView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        graphicView.axes.brain = brain
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        //graphView.axes.brain = brain
        let evaluate = graphicView.axes.brain?.graphicDisplay()
        label.text = evaluate?.description
    }
    
    
}
