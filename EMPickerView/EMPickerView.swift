//
//  EMPickerView.swift
//  EMPickerViewExample
//
//  Created by Emad A. on 4/02/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

// MARK: - EMPickerView
// MARK: -

class EMPickerView: UIView {

    // MARK: - Constants

    private let sectionsGap: CGFloat = 8
    private let componentRowId: String = "EMPickerViewComponentRow"
    private let defaultTintColor: UIColor = UIColor(red:0.28, green:0.61, blue:1, alpha:1)

    // MARK: - Public Properties

    var componentsRowHeight: CGFloat = 50

    @IBOutlet var delegate: EMPickerViewDelegate?
    @IBOutlet var dataSource: EMPickerViewDataSource? {
        didSet {
            setNeedsValidateDataSource()
        }
    }

    override var tintColor: UIColor! {
        didSet {
            for s in 0...sections.count {
                if let inds = indicators[s] {
                    inds.0.backgroundColor = self.tintColor
                    inds.1.backgroundColor = self.tintColor
                }
            }
        }
    }

    // MARK: - Private Properties

    private var sections = [UIView]()
    private var components = [Int: [UITableView]]()
    private var indicators = [Int: (UIView, UIView)]()

    // MARK: - Overriden Methods

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = defaultTintColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = defaultTintColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Setting the position of sections based on their index

        let uprightWidth: CGFloat = bounds.width - CGFloat(sections.count - 1) * sectionsGap

        var size: CGSize = CGSize(width: 0, height: bounds.height)
        let sws: [CGFloat]? = delegate?.widthFractionForSectionsInPickerView?(self)
        if sws == nil {
            size.width = ceil(uprightWidth / CGFloat(sections.count))
        }
        else {
            assert(sws!.count == sections.count, "The width of sections has been set improperly.")

            let ws = sws!.reduce(0) { $0 + $1 }
            assert(ws == 1, "The width of sections has been set improperly.")
        }

        for (s, section) in enumerate(sections) {
            var origin: CGPoint = CGPointMake(0, CGRectGetMinY(bounds))
            if sws != nil {
                size.width = uprightWidth * sws![s]
                if s == 0 {
                    origin.x = CGRectGetMinX(bounds)
                }
                else {
                    let previous = sections[s - 1]
                    origin.x = CGRectGetMaxX(previous.frame) + sectionsGap
                }
            }
            else {
                origin.x = CGFloat(s) * (size.width + sectionsGap)
            }
            section.frame = CGRect(origin: origin, size: size)

            // Setting the position of components of this section based on their index
            if let componentsForSection = components[s] {
                var size: CGSize = CGSizeMake(0, section.bounds.height)
                let cws: [CGFloat]? = delegate?.pickerView?(self, widthFractionForComponentsInSection: s)
                if cws == nil {
                    size.width = ceil(section.bounds.width / CGFloat(componentsForSection.count))
                }
                else {
                    assert(cws!.count == componentsForSection.count, "The width of components for section \(s) has been set improperly.")

                    let ws = cws!.reduce(0) { $0 + $1 }
                    assert(ws == 1, "The width of components for section \(s) has been set improperly.")
                }

                // Going through components of this section ...
                for (c, component) in enumerate(componentsForSection) {
                    var origin: CGPoint = CGPointMake(CGFloat(c) * size.width, CGRectGetMinY(section.bounds))
                    if cws != nil {
                        size.width = section.bounds.width * cws![c]
                        if c == 0 {
                            origin.x = CGRectGetMinX(section.bounds)
                        }
                        else {
                            let previous = componentsForSection[c - 1]
                            origin.x = CGRectGetMaxX(previous.frame)
                        }
                    }
                    component.frame = CGRect(origin: origin, size: size)
                    component.contentInset = UIEdgeInsetsMake(
                        (section.bounds.height - componentsRowHeight) / 2, 0,
                        (section.bounds.height - componentsRowHeight) / 2, 0);

                    var r: Int = 0;
                    if let selectedIndexPath = component.indexPathForSelectedRow() {
                        r = selectedIndexPath.row;
                    }
                    selectRowAtIndex(r, component: c, section: s, animated: false);
                }
            }

            // Setting the position of indicators of this section based on their index
            // Index 0 is for top and 1 is for bottom.
            if let indicatorsForSection = indicators[s] {
                indicatorsForSection.0.frame = CGRectMake(
                    CGRectGetMinX(section.bounds),
                    section.center.y - componentsRowHeight / 2,
                    section.bounds.width,
                    2)
                indicatorsForSection.1.frame = CGRectMake(
                    CGRectGetMinX(section.bounds),
                    section.center.y + componentsRowHeight / 2 - 2,
                    section.bounds.width,
                    2)
            }
        }
    }

    // MARK: - Public Methods

    func selectRowAtIndex(index: Int, component: Int, section: Int, animated: Bool) {
        let componentsAtSection: [UIView]? = components[section]
        if componentsAtSection == nil || componentsAtSection?.count < 1 {
            return
        }
        
        if let tableView = componentsAtSection![component] as? UITableView {
            tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: animated, scrollPosition: .None)
            tableView.scrollToNearestSelectedRowAtScrollPosition(.None, animated: animated)
        }

        self.delegate?.pickerView?(self, didSelectRowAtIndex: index, component: component, section: section)
    }

    func selectedRow(#component: Int, section: Int) -> Int {
        if let componentsOfSection = components[section] where componentsOfSection.count > component {
            let componentView: UITableView = componentsOfSection[component]
            return componentView.indexPathForSelectedRow()?.row ?? NSNotFound
        }

        return NSNotFound
    }

    // MARK: - Private Methods

    private func setNeedsValidateDataSource() {
        // Deallocating current sections view
        for sec: UIView in sections {
            sec.removeFromSuperview()
        }
        sections.removeAll(keepCapacity: false)

        // Initializing new sections and keeping a refrence of them for further uses
        let numberOfSections: Int = dataSource?.numberOfSectionsInPickerView?(self) ?? 1
        for var index: Int = 0; index < numberOfSections; index++ {
            let section: UIView = UIView()
            section.clipsToBounds = true

            addSubview(section)
            sections.append(section)
            
            initComponents(forSection: index)
            initIndicators(forSection: index)
        }
    }

    private func initComponents(forSection section: Int) {
        // Deallocating current components view for each section
        if let componentsForSection = components[section] {
            for comp: UIView in componentsForSection {
                comp.removeFromSuperview()
            }
            components.removeValueForKey(section)
        }

        // Initializing new components for given section index and keeping a reference of them for further uses
        var componentsForSection = [UITableView]()
        let sectionView: UIView = sections[section]

        let numberOfComponents: Int = dataSource?.pickerView(self, numberOfComponentsInSection: section) ?? 0
        for var index: Int = 0; index < numberOfComponents; index++ {
            let component: UITableView = UITableView()
            component.registerClass(EMPickerViewRow.self, forCellReuseIdentifier: componentRowId)
            component.showsHorizontalScrollIndicator = false
            component.showsVerticalScrollIndicator = false
            component.backgroundColor = UIColor.clearColor()
            component.separatorStyle = .None
            component.dataSource = self
            component.delegate = self

            if component.respondsToSelector(Selector("setLayoutMargins:")) {
                component.layoutMargins = UIEdgeInsetsZero
            }
            if component.respondsToSelector(Selector("setSeparatorInset:")) {
                component.separatorInset = UIEdgeInsetsZero
            }

            sectionView.addSubview(component)
            componentsForSection.append(component)
        }
        components[section] = componentsForSection
    }

    private func initIndicators(forSection section: Int) {
        // Deallocating current indicators view for each section
        if let indicatorsForSection = indicators[section] {
            indicatorsForSection.0.removeFromSuperview()
            indicatorsForSection.1.removeFromSuperview()
            indicators.removeValueForKey(section)
        }

        // Initializing new indicators for given section index and keeping a reference of them for further uses
        var indicatorsForSection = (UIView(), UIView())
        let sectionView: UIView = sections[section]

        indicatorsForSection.0.backgroundColor = tintColor
        sectionView.addSubview(indicatorsForSection.0)

        indicatorsForSection.1.backgroundColor = tintColor
        sectionView.addSubview(indicatorsForSection.1)

        indicators[section] = indicatorsForSection
    }

    private func scrollComponent(component: UITableView, toContentOffset offset: CGPoint, animated: Bool) {
        var point: CGPoint = offset
        let frame:CGRect = CGRectMake(0, floor((component.bounds.height - componentsRowHeight) / 2), component.bounds.width, componentsRowHeight);
        point.y = round((point.y + frame.origin.y) / frame.size.height) * frame.size.height;

        // Scrolling the component to proper place in order to bring the selection at center
        component.setContentOffset(CGPointMake(0, point.y - frame.origin.y), animated: animated)

        let componentIndexPath = indexForComponentView(component)
        let rowIndexPath: NSIndexPath? = component.indexPathForRowAtPoint(point)
        if rowIndexPath != nil && componentIndexPath.component != NSNotFound && componentIndexPath.section != NSNotFound {
            component.selectRowAtIndexPath(rowIndexPath, animated: false, scrollPosition: .None)
            delegate?.pickerView?(self, didSelectRowAtIndex: rowIndexPath!.row, component: componentIndexPath.component, section: componentIndexPath.section)
        }
    }

    private func indexForComponentView(component: UITableView) -> (component: Int, section: Int) {
        var componentIndex: Int = NSNotFound
        var sectionIndex: Int = NSNotFound
        var stop: Bool = false

        for (s, cms) in components {
            for (c, cm) in enumerate(cms) {
                if component.isEqual(cm) {
                    componentIndex = c
                    sectionIndex = s
                    stop = true
                    break
                }
            }
            if stop { break }
        }

        return (componentIndex, sectionIndex)
    }
}

// MARK: - UITableViewDataSource Methods
// MARK: -

extension EMPickerView: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = indexForComponentView(tableView)
        if dataSource != nil {
            return dataSource!.pickerView(self, numberOfRowsInComponent: index.component, section: index.section)
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(componentRowId) as! UITableViewCell
        cell.textLabel?.textAlignment = .Center

        let index = indexForComponentView(tableView)
        if index.component != NSNotFound && index.section != NSNotFound {
            if let text = delegate?.pickerView?(self, attributtedTitleForRow: indexPath.row, component: index.component, section: index.section) {
                cell.textLabel?.attributedText = text
            }
            else {
                cell.textLabel?.text = delegate?.pickerView(self, titleForRow: indexPath.row, component: index.component, section: index.section)
            }
        }

        return cell
    }
}

// MARK: - UITableViewDelegate Methods
// MARK: -

extension EMPickerView: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return componentsRowHeight
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexForComponentView(tableView)
        if index.component != NSNotFound && index.section != NSNotFound {
            selectRowAtIndex(indexPath.row, component: index.component, section: index.section, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate Methods
// MARK: -

extension EMPickerView: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let component: UITableView = scrollView as! UITableView

        let center: CGPoint = component.superview!.convertPoint(component.center, toView: component)
        let indexPathAtCenter: NSIndexPath? = component.indexPathForRowAtPoint(center)

        if let visibleIndexPaths = component.indexPathsForVisibleRows() as? [NSIndexPath] {
            // Going through visible index paths and find the one which is at center
            // All cells should not be selected but that one.
            for indexPath:NSIndexPath in visibleIndexPaths {
                if let cell = component.cellForRowAtIndexPath(indexPath) {
                    cell.setSelected(indexPath.isEqual(indexPathAtCenter), animated: true)
                }
            }
        }
    }

    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // When dragging end with no further animation and scrolling, velocity.y == 0,
        // component should scroll to the selected cell
        if velocity.y == 0 {
            scrollComponent(scrollView as! UITableView, toContentOffset: targetContentOffset.memory, animated: true)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // Scrolling to the selected cell
        scrollComponent(scrollView as! UITableView, toContentOffset: scrollView.contentOffset, animated: true)
    }
}