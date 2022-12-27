# Supported Attributes

Common attributes supported by all DOM elements.

## Overview

These attributes are supported by all elements, including custom ones. Individual elements may also support additional attributes.

## Attributes

- `navigation-title` (string): The navigation title of the current page. Only displayed when navgiation is enabled, see ``LiveViewConfiguration/navigationMode-swift.property``.
- `frame` (object): A JSON object containing either a fixed size (`width` and/or `height`) or flexible size (some combination of `min_width`, `ideal_width`, `max_width`, `min_height`, `ideal_height`, and `max_height`) as well as an alignment (how the view is aligned within the frame) which is one of the following values:
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
- `padding`: One of the following types:
    - A number that is the padding applied to all edges of the view
    - A JSON object containing values for the `top`, `bottom`, `leading`, and `trailing` edge padding
- `list-row-separator`: Whether the list row separator is shown for this view (if it's in a list).
    - `automatic` (default)
    - `hidden`
- `list-row-inset`: The inset for when the element is used as a list row. One of the following types:
    - A number that is the inset applied to all edges
    - A JSON object containing values for the `top`, `bottom`, `leading`, and `trailing` edges
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
