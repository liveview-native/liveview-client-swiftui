# AsyncImage

`<asyncimage>`, displays images loaded from a remote URL.

## Attributes

- `src` (required): The URL of the image to display.
- `scale` (float): The pixel scale of the image, if designed for high-resolution screens.
- `content-mode`: How the image is displayed within the view, if their aspect ratios are not the same.
    - `fit` (default): The image is displayed at its aspect ratio as large as possible without clipping.
    - `fill`: The image is cropped in to fill the entire view.
