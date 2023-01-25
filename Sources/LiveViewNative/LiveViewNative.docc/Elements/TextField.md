# TextField

`<text-field>`, a text field form element.

## Overview

This element must be contained inside a `<phx-form>` element.

## Attributes

- `name` (required): The name to use for this field's value in the form data.
- `value`: The initial value of the field.
- `placeholder`: The placeholder text to display when there is no value.
- `border-style`: The visual style of the text field.
    - `rounded` (default)
    - `none`
- `clear-button`: When the clear button is displayed.
    - `never` (default)
    - `always`
    - `while-editing`
- `autocorrection`: How autocorrect behaves.
    - `sentence` (default)
    - `none`
    - `words`
    - `all-characters`
- `keyboard`: Which keyboard to show when editing.
    - `default` (default)
    - `ascii-capable`
    - `numbers-and-punctuation`
    - `url`
    - `number-pad`
    - `phone-pad`
    - `name-phone-pad`
    - `email`
    - `decimal`
    - `twitter`
    - `ascii-capable-number-pad`
- `is-secure-text-entry`: Whether the contents are hidden (e.g., for password fields).
    - `no` (default)
    - `yes`
- `return-key-type`: The type of the return key on the keyboard.
    - `default` (default)
    - `go`
    - `google`
    - `join`
    - `next`
    - `route`
    - `search`
    - `send`
    - `yahoo`
    - `done`
    - `emergency-call`
    - `continue`
