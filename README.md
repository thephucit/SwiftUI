## CheckBox Swift
*Drag & drop file NTPCheckBox.swift to your project*

```swift
// init checkbox button
let checkbox = NTPCheckBox(frame: CGRectMake(20, 100, 200, 15), name: "smartPhone", text: "iphone", value: "1", checked: true)
   
// add checkbox to viewController
self.view.addSubview(checkbox)
```

## Popup Select List
*Drag & drop file NTPListPopup.swift to your project*

```swift
// from your viewController extend `NTPListPopupDelegate`
let data = ["1": "item1", "2": "item2"]
// data must be a dictionary [String: String] ~ [key:value]
let dialog = NTPListPopup(view: self, title: "your title", options: data)
dialog.delegate = self
dialog.show()
// get value when tap to cell in list popup
func NTPListPopupClickedAtButtonIndex(index: String)
{
   // index is the key in dictionary `data`
}
```
awesome :+1:
