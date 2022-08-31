# Supported Attributes

Common attributes supported by all DOM elements.

## Overview

These attributes are supported by all elements, including custom ones. Individual elements may also support additional attributes.

## Specifying Colors

Any attribute that accepts a color can be provided with:
- a CSS-style hexadecimal RGB color (e.g. `#ff33cc`)
- a named SwiftUI system color (prefix the SwiftUI property name with `system-`, e.g., `system-aqua` or `system-accent`)

## Shape Attributes

These attributes are common to all <doc:SupportedElements#Shapes>:

- `fill-color`: The color this shape is filled with (mutually exclusive with `stroke-color`, see <doc:SupportedAttributes#Specifying-Colors>)
- `stroke-color`: The color this shape is stroked with (mutually exclusive with `fill-color`, see <doc:SupportedAttributes#Specifying-Colors>)
