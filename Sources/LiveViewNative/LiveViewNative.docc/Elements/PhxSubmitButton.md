# PhxSubmitButton

`<phx-submit-button>`, special button that triggers submission of the form it's contained in when pressed.

## Attributes

The submit button also supports all the attributes of `<button>` (see <doc:Button>) except `phx-click`.

- `after-submit`: What builtin action (if any) to perform after the form is submitted.
    - `none` (default)
    - `clear`: Clears the form data
