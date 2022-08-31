# Supported Attributes

Common attributes supported by all DOM elements.

## Overview

These attributes are supported by all elements, including custom ones. Individual elements may also support additional attributes.

## Attributes

- `nav-title` (string): The navigation title of the current page. Only displayed when navgiation is enabled, see ``LiveViewConfiguration/navigationMode-swift.property``.
- `frame-width` (float): The width of the view frame.
- `frame-height` (float): The height of the view frame.
- `frame-alignment`: How the view is aligned within the frame created by the `frame-width` and `frame-height` attributes.
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
- `pad` (float): The padding for all edges of the view.
- `pad-top` (float): Padding for the top edge.
- `pad-bottom` (float): Padding for the bottom edge.
- `pad-leading` (float): Padding for the leading edge.
- `pad-trailing` (float): Padding for the trailing edge.
- `list-row-separator`: Whether the list row separator is shown for this view (if it's in a list).
    - `automatic` (default)
    - `hidden`
- `list-row-inset` (float): The inset for when the element is used as a list row.
- `list-row-inset-top` (float): The top inset when used as a list row.
- `list-row-inset-bottom` (float): The bottom inset when used as a list row.
- `list-row-inset-leading` (float): The leading inset when used as a list row.
- `list-row-inset-trailing` (float): The trailing inset when used as a list row.
- `tint`: The tint color of this element and its children. See <doc:SupportedAttributes#Specifying-Colors>


## Specifying Colors

Any attribute that accepts a color can be provided with:
- a CSS-style hexadecimal RGB color (e.g. `#ff33cc`)
- a named SwiftUI system color (prefix the SwiftUI property name with `system-`, e.g., `system-aqua` or `system-accent`)

## Shape Attributes

@Comment {
    the #Shapes link doesn't work due to a docc bug: https://forums.swift.org/t/docc-markdown-format-for-anchor-tags/55660/3
}

These attributes are common to all <doc:SupportedElements#Shapes>:

- `fill-color`: The color this shape is filled with (mutually exclusive with `stroke-color`, see <doc:SupportedAttributes#Specifying-Colors>)
- `stroke-color`: The color this shape is stroked with (mutually exclusive with `fill-color`, see <doc:SupportedAttributes#Specifying-Colors>)
