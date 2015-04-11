//
//  EMPickerViewRow.swift
//  EMPickerViewExample
//
//  Created by Emad A. on 7/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

class EMPickerViewRow: UITableViewCell {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if let label = self.textLabel {
            let textLabelAlpha: CGFloat = selected ? 1.0 : 0.5
            UIView.animateWithDuration(0.25, animations: { label.alpha = textLabelAlpha })
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textLabel?.frame = textLabel?.superview?.bounds ?? CGRectZero
    }

    private func initialize() {
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        if respondsToSelector(Selector("setLayoutMargins:")) {
            layoutMargins = UIEdgeInsetsZero
        }
        if respondsToSelector(Selector("setSeparatorInset:")) {
            separatorInset = UIEdgeInsetsZero
        }
    }
}
