//
//  Group.swift
//  
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI

/// A collection of elements.
///
/// You can use groups to apply modifiers to multiple elements without code duplication.
///
/// ```html
/// <Group modifiers={tint(:orange)}>
///     <Button>Orange Button</Button>
///     <Toggle>Orange Toggle</Toggle>
///     <Slider>Orange Slider</Slider>
/// </Group>
/// ```
///
/// Groups can also be used to surpass the 10 child limit.
///
/// ```html
/// <VStack>
///     <Group>
///         <Text>1</Text>
///         <Text>2</Text>
///         <Text>3</Text>
///         <Text>4</Text>
///         <Text>5</Text>
///         <Text>6</Text>
///         <Text>7</Text>
///         <Text>8</Text>
///         <Text>9</Text>
///         <Text>10</Text>
///     </Group>
///     <Text>11</Text>
/// </VStack>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Group<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    public var body: some View {
        SwiftUI.Group {
            context.buildChildren(of: element)
        }
    }
}
