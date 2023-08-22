//
//  PresentationBackgroundModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/1/23.
//

import SwiftUI

/// Sets the background of a sheet-presented view.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// The background can be a shape style, specified with the ``style`` argument, or another view, specified as the content reference.
///
/// This example uses a shape style:
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(content: :content, is_presented: :show)}>
///   Present Sheet
///
///   <VStack template={:content} modifiers={presentation_background({:linear_gradient, [gradient: {:colors, [:red, :blue]}]})}>
///     <presentation_background:background>
///       <Color name="system-orange" />
///     </presentation_background:background>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
/// ## Arguments
/// - ``style``
/// - ``content``
/// - ``alignment``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct PresentationBackgroundModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The shape style to use as the background for the sheet content.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyShapeStyle`` for how to specify styles
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: AnyShapeStyle?
    /// A reference to the view to use as the background content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String?
    /// How to align the ``content`` view within the sheet.
    ///
    /// This value is not used when a style is provided, as shape styles fill the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let alignment: Alignment?
    
    @LiveContext<R> private var context
    @ObservedElement private var element
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let style = try container.decodeIfPresent(AnyShapeStyle.self, forKey: .style) {
            self.style = style
            self.content = nil
            self.alignment = nil
        } else {
            self.style = nil
            self.content = try container.decode(String.self, forKey: .content)
            self.alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment)
        }
    }
    
    func body(content: Content) -> some View {
        if let style {
            content.presentationBackground(style)
        } else {
            content.presentationBackground(alignment: alignment ?? .center) {
                context.buildChildren(of: element, forTemplate: self.content!)
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case style
        case alignment
        case content
    }
}
