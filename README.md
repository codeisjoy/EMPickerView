# EMPickerView
A customisable picker view in Swift

![EMPickerView Screenshot](https://github.com/codeisjoy/EMPickerView/blob/master/EMPickerView_Date_Time.png)

The user interface provided by a picker view consists of sections, components and rows.
* A section is a set of components which have the same indicator lines.
Each section has an indexed location (left to right) in the picke view.
* A component is a wheel, which has a series of items (rows) at indexed locations on the wheel.
Each component, same as section, has an indexed location (left to right) in its section.
Each row on a component could have a label, which is a simple or attributed string.

## Usage
It is a subclass of UIView so could be initialized either in Storyboard or by code.

    let pickerView: EMPickerView = EMPickerView(frame: <#CGRect#>)

Then set the `dataSource` and `delegate` properties.
The methods of `EMPickerViewDataSource` and `EMPickerViewDelegate` will control how the picker view looks like.

#### Properties

- `componentsRowHeight`<br/>
A float value indicating the height of the component rows
<hr/>
- `tintColor`<br/>
The tint colour to apply to the selection indicator lines

#### The data source `EMPickerViewDataSource`:

- `func pickerView(pickerView: EMPickerView, numberOfComponentsInSection section: Int) -> Int`<br/>
Called by the picker view when it needs the number of components for a specific section. (required)
<hr/>
- `func pickerView(pickerView: EMPickerView, numberOfRowsInComponent component: Int, section: Int) -> Int`<br/>
Called by the picker view when it needs the number of rows for a specific component of a specific section. (required)
<hr/>
- `optional func numberOfSectionsInPickerView(pickerView: EMPickerView) -> Int`<br/>
Called by the picker view when it needs the number of section. (optional)<br/>
If it is not defined default value 1 will be returned.

#### The delegate `EMPickerViewDelegate`:

- `optional func widthFractionForSectionsInPickerView(pickerView: EMPickerView) -> [CGFloat]`<br/>
Called by the picker view when it needs the section width to use for drawing the content.<br/>
You should return an array of `CGFloat` between `0` and `1`. Each number represents the section width portion at that index.<br/>
If this method is not implemented all sections will have the same width through the picker view.
<hr/>
- `optional func pickerView(pickerView: EMPickerView, widthFractionForComponentsInSection section: Int) -> [CGFloat]?`<br/>
Called by the picker view when it needs the components width to use for drawing the content.<br/>
You should return an array of `CGFloat` between `0` and `1`. Each number represents the section width portion at that index.
If this method is not implemented all components will have the same width through its section.
<hr/>
- `func pickerView(pickerView: EMPickerView, titleForRow row: Int, component: Int, section: Int) -> String`<br/>
Called by the picker view when it needs the title to use for a given row in a given component and section.
<hr/>
- `optional func pickerView(pickerView: EMPickerView, attributtedTitleForRow row: Int, component: Int, section: Int) -> NSAttributedString?`<br/>
Called by the picker view when it needs the styled title to use for a given row in a given component.<br/>
If you implement both this method and the `pickerView:titleForRow:component:section` method, the picker view prefers the use of this method.
However, if your implementation of this method returns nil, the picker view falls back to using the string returned by the pickerView:titleForRow:component:section method.
<hr/>
- `optional func pickerView(pickerView: EMPickerView, didSelectRowAtIndex row: Int, component: Int, section: Int)`<br/>
Called by the picker view when the user selects a row in a component and section and gives their index values.

## Install
Simply add it as a submodule then import `EMPickerView` folder into your Xcode project.

	git submodule add https://github.com/codeisjoy/EMPickerView.git <your lib directory>

## Note
This is the basic picker view. To have a date/time picker view the only thing that should be done is providing your date and time data through the `dataSource` methods and modifying the `delegate` methods to have your own picker view set.