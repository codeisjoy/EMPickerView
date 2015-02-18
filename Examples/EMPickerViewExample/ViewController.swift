//
//  ViewController.swift
//  EMPickerViewExample
//
//  Created by Emad A. on 4/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pv:EMPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        pv?.delegate = self;
        pv?.dataSource = self;

        pv?.selectRowAtIndex(3, component: 1, section: 0, animated: false)

        view.addSubview(pv!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: EMPickerViewDataSource {

    func numberOfSectionsInPickerView(pickerView: EMPickerView) -> Int {
        return 3
    }

    func pickerView(pickerView: EMPickerView, numberOfComponentsInSection section: Int) -> Int {
        return section == 0 ? 3 : 1
    }

    func pickerView(pickerView: EMPickerView, numberOfRowsInComponent component: Int, section: Int) -> Int {
        return component > 1 ? 2 : 10
    }
}

extension ViewController: EMPickerViewDelegate {

    func pickerView(pickerView: EMPickerView, titleForRow row: Int, component: Int, section: Int) -> String {
        return "\(section):\(component):\(row)"
    }
    
    func pickerView(pickerView: EMPickerView, attributtedTitleForRow row: Int, component: Int, section: Int) -> NSAttributedString? {
        var text: NSMutableAttributedString = NSMutableAttributedString(string: "\(section):\(component):\(row)")
        text.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir-Medium", size: 16)!, range: NSMakeRange(0, text.length))

        if (section == 0 && component == 1) {
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Left

            text.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, text.length))
        }

        return text
    }

    func widthFractionForSectionsInPickerView(pickerView: EMPickerView) -> [CGFloat] {
        return [0.6, 0.2, 0.2]
    }

    func pickerView(pickerView: EMPickerView, widthForComponentsInSection section: Int) -> [CGFloat]? {
        if section == 0 {
            return [0.3, 0.4, 0.3]
        }
        
        return nil
    }

    func pickerView(pickerView: EMPickerView, didSelectRowAtIndex row: Int, component: Int, section: Int) {
        //println("Selected: Row", row, "Component", component, "Section", section)
    }
}