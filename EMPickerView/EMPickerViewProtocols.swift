//
//  EMPickerViewDataSource.swift
//  EMPickerViewExample
//
//  Created by Emad A. on 4/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit
import Foundation

// MARK: - EMPickerViewDataSource
// MARK: -

@objc protocol EMPickerViewDataSource {

    // Called by the picker view when it needs the number of section. (optional)
    // If it is not defined default value 1 will be returned.
    optional func numberOfSectionsInPickerView(pickerView: EMPickerView) -> Int

    // Called by the picker view when it needs the number of components for a specific section. (required)
    func pickerView(pickerView: EMPickerView, numberOfComponentsInSection section: Int) -> Int

    // Called by the picker view when it needs the number of rows for a specific component of a specific section. (required)
    func pickerView(pickerView: EMPickerView, numberOfRowsInComponent component: Int, section: Int) -> Int
}

// MARK: - EMPickerViewDelegate
// MARK: -

@objc protocol EMPickerViewDelegate {

    // Called by the picker view when it needs the section width to use for drawing the content.
    // You should return an array of CGFloat between 0 and 1. Each number represents the section width portion at that index.
    // If this method is not implemented all sections will have the same width through the picker view.
    optional func widthFractionForSectionsInPickerView(pickerView: EMPickerView) -> [CGFloat]

    // Called by the picker view when it needs the components width to use for drawing the content.
    // You should return an array of CGFloat between 0 and 1. Each number represents the section width portion at that index.
    // If this method is not implemented all components will have the same width through its section.
    optional func pickerView(pickerView: EMPickerView, widthFractionForComponentsInSection section: Int) -> [CGFloat]?

    // Called by the picker view when it needs the title to use for a given row in a given component and section.
    func pickerView(pickerView: EMPickerView, titleForRow row: Int, component: Int, section: Int) -> String

    // Called by the picker view when it needs the styled title to use for a given row in a given component.
    // If you implement both this method and the pickerView:titleForRow:component:section method, the picker view prefers the use of this method.
    // However, if your implementation of this method returns nil, the picker view falls back to using the string returned by
    // the pickerView:titleForRow:component:section method.
    optional func pickerView(pickerView: EMPickerView, attributtedTitleForRow row: Int, component: Int, section: Int) -> NSAttributedString?

    // Called by the picker view when the user selects a row in a component and section and gives their index values.
    optional func pickerView(pickerView: EMPickerView, didSelectRowAtIndex row: Int, component: Int, section: Int)

}