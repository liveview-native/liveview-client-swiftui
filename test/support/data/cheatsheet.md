### `<Menu>`
Tappable element that expands to reveal a list of options.



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



