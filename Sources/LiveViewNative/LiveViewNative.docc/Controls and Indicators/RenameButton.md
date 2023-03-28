# <RenameButton>

Performs the current rename action when pressed.

## Overview

Use the ``RenameActionModifier`` modifier to set the event to send when tapped.

```html
<RenameButton
    modifiers={
        rename_action(@native, event: "begin_rename", target: @myself)
    }
/>
```

## SwiftUI Documentation
See [`SwiftUI.RenameButton`](https://developer.apple.com/documentation/swiftui/RenameButton) for more details on this View.

## See Also
### Sending Events
* ``RenameActionModifier``
