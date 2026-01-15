import UniformTypeIdentifiers
import SwiftSyntax

/// SyntaxConvertible conformance for UTType.
/// Parses member access expressions like `.pdf`, `.image`, `.plainText`, etc.
///
/// Example usage in markup:
/// ```html
/// <view modifiers='fileImporter(isPresented: $showPicker, allowedContentTypes: [.pdf, .image])'>
/// ```
extension UTType: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Parse .identifier syntax (e.g., .pdf, .image, .plainText)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            let name = memberAccess.declName.baseName.text
            switch name {
            // Common document types
            case "pdf": self = .pdf
            case "plainText": self = .plainText
            case "rtf": self = .rtf
            case "html": self = .html
            case "xml": self = .xml
            case "json": self = .json
            case "yaml": self = .yaml
            case "sourceCode": self = .sourceCode
            case "text": self = .text
            case "data": self = .data
            case "content": self = .content
            case "item": self = .item

            // Image types
            case "image": self = .image
            case "png": self = .png
            case "jpeg": self = .jpeg
            case "gif": self = .gif
            case "bmp": self = .bmp
            case "ico": self = .ico
            case "rawImage": self = .rawImage
            case "svg": self = .svg
            case "heic": self = .heic
            case "heif": self = .heif
            case "tiff": self = .tiff
            case "webP": self = .webP

            // Audio types
            case "audio": self = .audio
            case "mp3": self = .mp3
            case "mpeg4Audio": self = .mpeg4Audio
            case "wav": self = .wav
            case "aiff": self = .aiff
            case "midi": self = .midi

            // Video types
            case "movie": self = .movie
            case "video": self = .video
            case "mpeg": self = .mpeg
            case "mpeg2Video": self = .mpeg2Video
            case "mpeg4Movie": self = .mpeg4Movie
            case "quickTimeMovie": self = .quickTimeMovie
            case "avi": self = .avi

            // Archive types
            case "archive": self = .archive
            case "gzip": self = .gzip
            case "bz2": self = .bz2
            case "zip": self = .zip

            // Spreadsheet/presentation types
            case "spreadsheet": self = .spreadsheet
            case "presentation": self = .presentation

            // File system types
            case "folder": self = .folder
            case "directory": self = .directory
            case "package": self = .package
            case "bundle": self = .bundle
            case "application": self = .application
            case "executable": self = .executable

            // Apple-specific types
            case "propertyList": self = .propertyList
            case "appleScript": self = .appleScript
            case "javaScript": self = .javaScript

            // Email types
            case "emailMessage": self = .emailMessage
            case "vCard": self = .vCard
            case "calendarEvent": self = .calendarEvent

            default:
                return nil
            }
            return
        }
        return nil
    }
}

// Note: Array conformance for UTType is handled by the generic Array: SyntaxConvertible
// extension in GradientStop.swift since UTType now conforms to SyntaxConvertible.
