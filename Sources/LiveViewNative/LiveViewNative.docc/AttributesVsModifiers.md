# Attributes vs. Modifiers

## Overview

In LiveViewNative, there are two distinct methods for applying changes to elements: attributes and modifiers.

Attributes apply to only a specific element, and are represented in your templates like HTML attributes. They store a single string value, such as `placeholder` on <doc:TextField>. They are implemented on specific view types and are only applicable to that view/element.

Modifiers, on the other hand, represent changes that can be applied to a large swath of elements. They are stored as JSON objects within a JSON array (becuase the behavior when composing modifiers may be order-dependent) on the `modifiers` attribute of an element. Thus, they can hold multiple related values, such as the distinct values for the `padding` modifier's edges. Modifiers are implemented separately from any particular view type and therefore cannot directly access or manipulate particular views.

When choosing between an attribute and a modifier for a customization in your app, consider how broadly those changes are applicable. If they only apply to a single element, use an attribute implemented directly on that element. If they apply to all elements, or a broad category of them, use a modifier to be able to easily reuse your changes.
