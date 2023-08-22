//
//  FrameModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI

/// Creates a frame to contain an element.
///
/// Use this modifier to set the size of an element.
///
/// - Note: Not all elements will respect the size provided by a frame.
/// It is up to the element to decide its final size.
///
/// There are two types of frame, fixed and flexible.
///
/// Create a fixed frame with a `width` and/or `height`.
///
/// ```html
/// <Rectangle modifiers={frame(width: 100, height: 50)} />
/// ```
///
/// A flexible frame will choose a size between a min and max.
///
/// ```html
/// <Rectangle modifiers={frame(min_width: 0, ideal_width: 15, max_width: 50)} />
/// ```
///
/// Use a very large `max_width` or `max_height` to make an element fill its parent.
///
/// ```html
/// <Rectangle modifiers={frame(max_width: 99999, max_height: 99999)} />
/// ```
///
/// - Note: Fixed and flexible frame arguments cannot be mixed. Fixed frame arguments will take precedence.
///
/// ## Arguments
/// * ``width``
/// * ``height``
/// * ``minWidth``
/// * ``idealWidth``
/// * ``maxWidth``
/// * ``minHeight``
/// * ``idealHeight``
/// * ``maxHeight``
/// * ``alignment``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FrameModifier: ViewModifier, Decodable, Equatable {
    /// A fixed width for the element.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let width: CGFloat?
    /// A fixed height for the element.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let height: CGFloat?
    
    /// The minimum allowed width.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let minWidth: CGFloat?
    /// The ideal width, used with ``minWidth`` and ``maxWidth``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let idealWidth: CGFloat?
    /// The maximum allowed width.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let maxWidth: CGFloat?
    
    
    /// The minimum allowed height.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let minHeight: CGFloat?
    /// The ideal height, used with ``minHeight`` and ``maxHeight``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let idealHeight: CGFloat?
    /// The maximum allowed height.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let maxHeight: CGFloat?
    
    /// The alignment of elements within the frame. Defaults to `center`.
    ///
    /// See ``LiveViewNative/SwiftUI/Alignment`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        if width != nil || height != nil {
            content.frame(width: width, height: height, alignment: alignment)
        } else {
            content.frame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
        }
    }
}
