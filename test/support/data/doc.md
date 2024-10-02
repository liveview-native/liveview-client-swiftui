# Menu
<!-- tooltip support -->
<div id="Menu/1" class="detail">

<h1 style="display: none;">

&lt;Menu&gt;

</h1>

<section class="docstring">
  <p>Tappable element that expands to reveal a list of options.</p>
</section>

</div>
<!-- end tooltip support -->

## Overview
Provide the `content` and `label` children to create a menu.

```heex
<Menu>
    <Text template={:label}>
        Edit Actions
    </Text>
    <Group template={:content}>
        <Button phx-click="arrange">Arrange</Button>
        <Button phx-click="update">Update</Button>
        <Button phx-click="remove">Remove</Button>
    </Group>
</Menu>
```
Menus can be nested by including another [`<Menu>`](menu.html#/documentation/liveviewnative/menu/1) in the `content`.
## Children
* `label` - Describes the content of the menu.
* `content` - Elements displayed when expanded.

## SwiftUI Documentation
See [`SwiftUI.Menu`](https://developer.apple.com/documentation/swiftui/Menu) for more details on this View.
