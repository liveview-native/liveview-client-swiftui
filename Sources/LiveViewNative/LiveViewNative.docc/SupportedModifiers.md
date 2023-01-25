# Supported Modifiers

Common modifiers supported by all DOM elements.

## Overview

These attributes are supported by all elements, including custom ones. Modifiers are specified as a JSON array of objects on elements.

```html
<h-stack modifiers='[{"type": "padding", "all": 16}]'>
    <!-- ... -->
</h-stack>
```

## Attributes

- `navigation_title`: The navigation title of the current page. Only displayed when navgiation is enabled, see ``LiveViewConfiguration/navigationMode-swift.property``. Properties:
    - `title` (string): The navigation title.
- `frame`: A fixed size or flexible size frame around the modified view. Note that the fixed and flexible properties are mutually exclusive. All properties are optional. Properties:
    - `width` (number): The width of the frame.
    - `height` (number): The height of the frame.
    - `min_width` (number): The minimum width of the frame.
    - `ideal_width` (number): The ideal width of the frame.
    - `max_width` (number): The maximum width of the frame.
    - `min_height` (number): The minimum height of the frame.
    - `ideal_height` (number): The ideal height of the frame.
    - `max_height` (number): The maximum height of the frame.
    - `alignment` (string): How the view is aligned within the frame. One of the following values:
        - `top-leading`
        - `top`
        - `top-trailing`
        - `leading`
        - `center` (default)
        - `trailing`
        - `bottom-leading`
        - `bottom`
        - `bottom-trailing`
        - `leading-last-text-baseline`
        - `trailing-last-text-baseline`
- `padding`: The padding to apply around the edges of the view. All properties are optional. Properties:
    - `all` (number): The padding for all edges. If used, other properties are ignored.
    - `top` (number): The top edge padding.
    - `bottom` (number): The bottom edge padding.
    - `leading` (number): The leading edge padding.
    - `trailing` (number): The trailing edge padding.
- `list_row_separator`: The configuration for the separator of this list row. Properties:
    - `visibility`: The separator visibility. Possible values:
        - `hidden`: The separator is hidden.
        - `visible`: The separator is shown.
        - `automatic`: The separator visibility is determined automatically by the platform.
    - `edges`: Which edges the list separator visibility applies to. Possible values:
        - `top`
        - `bottom`
        - `all` (default)
- `list_row_inset`: Insets for the list row, overriding the default insets. Properties:
    - `all` (number): The inset for all edges. If used, other properties are ignored.
    - `top` (number): The top inset.
    - `bottom` (number): The bottom inset.
    - `leading` (number): The leading inset.
    - `trailing` (number): The trailing inset.
- `tint`: The tint color of this view and all nested views. Properties:
    - `color` (string): The tint color. See <doc:SupportedModifiers#Specifying-Colors>.

## Specifying Colors

Any attribute that accepts a color can be provided with:
- a CSS-style hexadecimal RGB color (e.g. `#ff33cc`)
- a named SwiftUI system color (prefix the SwiftUI property name with `system-`, e.g., `system-aqua` or `system-accent`)

## Shape Attributes

@Comment {
    the #Shapes link doesn't work due to a docc bug: https://forums.swift.org/t/docc-markdown-format-for-anchor-tags/55660/3
}

These attributes are common to all <doc:SupportedElements#Shapes>:

- `fill-color`: The color this shape is filled with (mutually exclusive with `stroke-color`, see <doc:SupportedModifiers#Specifying-Colors>)
- `stroke-color`: The color this shape is stroked with (mutually exclusive with `fill-color`, see <doc:SupportedModifiers#Specifying-Colors>)
