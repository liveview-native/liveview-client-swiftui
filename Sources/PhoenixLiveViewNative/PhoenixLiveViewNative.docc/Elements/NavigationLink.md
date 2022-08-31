# NavigationLink

`<navigationlink>`, links to another live view page.

## Attributes

- `data-phx-link`: Must be `redirect`
- `data-phx-link-state`: How the link is presented. See ``LiveViewConfiguration/navigationMode-swift.property``.
    - `push`: A new view is pushed onto the navigation stack
    - `replace`: The current view is replaced.
- `data-phx-href`: The link destination.
- `disabled`: If present, the link is disabled.
