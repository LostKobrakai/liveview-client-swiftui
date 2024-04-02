//
//  Text.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LiveViewNativeCore

/// Displays text.
///
/// There are a number of modes for displaying text.
///
/// ### Raw Strings
/// Using text content or the `verbatim` attribute will display the given string.
/// ```html
/// <Text>Hello</Text>
/// <Text verbatim="Hello"/>
/// ```
/// ### Dates
/// Provide an ISO 8601 date (with optional time) in the ``date`` attribute, and optionally a ``LiveViewNative/SwiftUI/Text/DateStyle`` in the ``dateStyle`` attribute.
/// Valid date styles are `date` (default), `time`, `relative`, `offset`, and `timer`.
/// The displayed date is formatted with the user's locale.
/// ```html
/// <Text date="2023-03-14T15:19:00.000Z" dateStyle="date"/>
/// ```
/// ### Date Ranges
/// Displays a localized date range between the given ISO 8601-formatted ``dateStart`` and ``dateEnd``.
/// ```html
/// <Text date:start="2023-01-01" date:end="2024-01-01"/>
/// ```
/// ### Markdown
/// The value of the ``markdown`` attribute is parsed as Markdown and displayed. Only inline Markdown formatting is shown.
///
/// ```html
/// <Text markdown="Hello, *world*!" />
/// ```
///
/// ### Formatted Values
/// A value should provided in the `value` attribute, or in the inner text of the element. The value is formatted according to the `format` attribute:
/// - `dateTime`: The `value` is an ISO 8601 date (with optional time).
/// - `url`: The value is a URL.
/// - `iso8601`: The `value` is an ISO 8601 date (with optional time).
/// - `number`: The value is a `Double`. Shown in a localized number format.
/// - `percent`: The value is a `Double`.
/// - `currency`: The value is a `Double` and is shown as a localized currency value using the currency specified in the `currencyCode` attribute.
/// - `name`: The value is a string interpreted as a person's name. The `nameStyle` attribute determines the format of the name and may be `short`, `medium` (default), `long`, or `abbreviated`.
///
/// ```html
/// <Text value={15.99} format="currency" currencyCode="usd" />
/// <Text value="Doe John" format="name" nameStyle="short" />
/// ```
///
/// ## Formatting Text
/// Use text modifiers to customize the appearance of text.
///
/// ```elixir
/// "large-bold" do
///     font(.largeTitle)
///     bold()
/// end
/// ```
///
/// ```html
/// <Text class="large-bold">
///     Hello, world!
/// </Text>
/// ```
///
/// ## Nesting Elements
/// Certain elements may be nested within a ``Text``.
/// - ``Text``: Text elements can be nested to adjust the formatting for only particular parts of the text.
/// - ``Link``: Allows tappable links to be included in text.
/// - ``Image``: Embeds images in the text.
///
/// - Note: Text modifiers can be used on nested ``Text`` elements, but other modifiers cannot.
///
/// ```html
/// <Text>
///     <Image systemName="person.crop.circle.fill" /><Text value="Doe John" format="name" class="blue bold" />
///     <Text verbatim={"\n"} />
///     Check out this thing I made: <Link destination="mysite.com">mysite.com</Link>
/// </Text>
/// ```
///
/// ## Attributes
/// * ``verbatim``
/// * ``markdown``
/// * ``date``
/// * ``dateStart``
/// * ``dateEnd``
/// * ``value``
/// * ``format``
/// * ``currencyCode``
/// * ``nameStyle``
/// * ``dateStyle``
@_documentation(visibility: public)
struct Text<R: RootRegistry>: View {
    @LiveContext<R> private var context
    
    @ObservedElement private var element: ElementNode
    
    /// A string value to use as the text content.
    ///
    /// In most cases, you should provide the content as a child of the element.
    /// 
    /// ```html
    /// <Text>Hello, world!</Text>
    /// ```
    @_documentation(visibility: public)
    @Attribute(.init(name: "content")) private var content: String?
    
    /// A string value to use as the text content without modification.
    ///
    /// In some cases, whitespaces and newlines in the text content are trimmed.
    /// Use this attribute to avoid trimming.
    ///
    /// ```html
    /// <Text verbatim=" Hello, world! " />
    /// <Text verbatim={"\n"} />
    /// ```
    @_documentation(visibility: public)
    @Attribute(.init(name: "verbatim")) private var verbatim: String?
    
    /// The value of this attribute is parsed as markdown.
    ///
    /// - Note: Only inline markdown is rendered.
    ///
    /// ```html
    /// <Text markdown="Hello, *world*!" />
    /// ```
    @_documentation(visibility: public)
    @Attribute(.init(name: "markdown")) private var markdown: String?
    
    /// Render an Elixir date.
    ///
    /// Use the ``dateStyle`` attribute to customize how the date is drawn.
    ///
    /// - Note: The value is expected to be in ISO 8601 format (with optional time)
    ///
    /// ```html
    /// <Text date={DateTime.utc_now()} dateStyle="date" />
    /// ```
    @_documentation(visibility: public)
    @Attribute(.init(name: "date")) private var date: Date?
    /// The lower bound of a date range.
    ///
    /// Use this attribute with the ``dateEnd`` attribute to display a date range.
    ///
    /// - Note: The value is expected to be in ISO 8601 format (with optional time)
    ///
    /// ```html
    /// <Text date:start={DateTime.utc_now()} date:end={DateTime.add(DateTime.utc_now(), 3, :day)} />
    /// ```
    @_documentation(visibility: public)
    @Attribute(.init(namespace: "date", name: "start")) private var dateStart: Date?
    /// The upper bound of a date range.
    ///
    /// Use this attribute with the ``dateStart`` attribute to display a date range.
    ///
    /// - Note: The value is expected to be in ISO 8601 format (with optional time)
    ///
    /// ```html
    /// <Text date:start={DateTime.utc_now()} date:end={DateTime.add(DateTime.utc_now(), 3, :day)} />
    /// ```
    @_documentation(visibility: public)
    @Attribute(.init(namespace: "date", name: "end")) private var dateEnd: Date?
    
    /// A value to format.
    ///
    /// Use the ``format`` attribute to choose how this value should be formatted.
    @_documentation(visibility: public)
    @Attribute(.init(name: "value")) private var value: String?
    /// The format of ``value``.
    ///
    /// Possible values:
    /// - `date-time`: The ``value`` is an ISO 8601 date (with optional time).
    /// - `url`: The value is a URL.
    /// - `iso8601`: The ``value`` is an ISO 8601 date (with optional time).
    /// - `number`: The value is a `Double`. Shown in a localized number format.
    /// - `percent`: The value is a `Double`.
    /// - `currency`: The value is a `Double` and is shown as a localized currency value using the currency specified in the ``currencyCode`` attribute.
    /// - `name`: The value is a string interpreted as a person's name. The ``nameStyle`` attribute determines the format of the name and may be `short`, `medium` (default), `long`, or `abbreviated`.
    @_documentation(visibility: public)
    @Attribute(.init(name: "format")) private var format: String?
    /// The currency code to use with the `currency` format.
    @_documentation(visibility: public)
    @Attribute(.init(name: "currencyCode")) private var currencyCode: String?
    /// The style for a `name` format.
    ///
    /// See ``LiveViewNative/Foundation/PersonNameComponents/FormatStyle/Style`` for a list of possible values.
    @_documentation(visibility: public)
    @Attribute(.init(name: "nameStyle")) private var nameStyle: PersonNameComponents.FormatStyle.Style = .medium
    /// The style for a ``date`` value.
    ///
    /// See ``LiveViewNative/SwiftUI/Text/DateStyle`` for a list of possible values.
    @_documentation(visibility: public)
    @Attribute(.init(name: "dateStyle")) private var dateStyle: SwiftUI.Text.DateStyle = .date
    
    @ClassModifiers<R> private var modifiers
    
    let overrideText: SwiftUI.Text?
    
    init(text: SwiftUI.Text? = nil) {
        self.overrideText = text
    }
    
    init(element: ElementNode, overrideStylesheet: Stylesheet<R>?, overrideText: SwiftUI.Text? = nil) {
        self._element = .init(element: element)
        self._content = .init(wrappedValue: nil, "content", element: element)
        self._verbatim = .init(wrappedValue: nil, "verbatim", element: element)
        self._date = .init(
            wrappedValue: nil,
            "date",
            element: element
        )
        self._dateStart = .init(
            wrappedValue: nil,
            "date:start",
            element: element
        )
        self._dateEnd = .init(
            wrappedValue: nil,
            "date:end",
            element: element
        )
        self._markdown = .init(wrappedValue: nil, "markdown", element: element)
        self._format = .init(wrappedValue: nil, "format", element: element)
        self._value = .init(wrappedValue: nil, "value", element: element)
        self._currencyCode = .init(wrappedValue: nil, "currencyCode", element: element)
        self._nameStyle = .init(wrappedValue: .medium, "nameStyle", element: element)
        self._dateStyle = .init(wrappedValue: .date, "dateStyle", element: element)
        self._modifiers = .init(element: element, overrideStylesheet: overrideStylesheet)
        self.overrideText = overrideText
    }
    
    public var body: SwiftUI.Text {
        if _modifiers.overrideStylesheet != nil {
            return modifiers.reduce(text) { result, modifier in
                if case let ._anyTextModifier(textModifier) = modifier {
                    return textModifier.apply(to: result, on: element)
                } else {
                    return result
                }
            }
        } else {
            return text
        }
    }
    
    private var text: SwiftUI.Text {
        if let overrideText {
            return overrideText
        } else if let content {
            return SwiftUI.Text(content)
        } else if let verbatim {
            return SwiftUI.Text(verbatim: verbatim)
        } else if let date {
            return SwiftUI.Text(date, style: dateStyle)
        } else if let dateStart,
                  let dateEnd
        {
            return SwiftUI.Text(dateStart...dateEnd)
        } else if let markdown {
            return SwiftUI.Text(.init(markdown))
        } else if let format {
            let innerText = value ?? element.innerText()
            switch format {
            case "dateTime":
                if let date = try? Date(innerText, strategy: .elixirDateTimeOrDate) {
                    return SwiftUI.Text(date, format: .dateTime)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "url":
                if let url = URL(string: innerText) {
                    return SwiftUI.Text(url, format: .url)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "iso8601":
                if let date = try? Date(innerText, strategy: .elixirDateTimeOrDate) {
                    return SwiftUI.Text(date, format: .iso8601)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "number":
                if let number = Double(innerText) {
                    return SwiftUI.Text(number, format: .number)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "percent":
                if let number = Double(innerText) {
                    return SwiftUI.Text(number, format: .percent)
                } else {
                    return SwiftUI.Text("")
                }
            case "currency":
                if let code = currencyCode,
                   let number = Double(innerText) {
                    return SwiftUI.Text(number, format: .currency(code: code))
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "name":
                if let nameComponents = try? PersonNameComponents(innerText) {
                    return SwiftUI.Text(nameComponents, format: .name(style: nameStyle))
                } else {
                    return SwiftUI.Text(innerText)
                }
            default:
                return SwiftUI.Text(innerText)
            }
        } else {
            return element.children().reduce(into: SwiftUI.Text("")) { prev, next in
                switch next.data {
                case let .element(data):
                    guard !data.attributes.contains(where: { $0.name == "template" })
                    else { return }
                    
                    let element = ElementNode(node: next, data: data)
                    
                    switch data.tag {
                    case "Text":
                        prev = prev + Self(
                            element: element,
                            overrideStylesheet: _modifiers.overrideStylesheet ?? (_modifiers.stylesheet as! Stylesheet<R>)
                        ).body
                    case "Link":
                        prev = prev + SwiftUI.Text(
                            .init("[\(element.innerText())](\(element.attributeValue(for: "destination")!))")
                        )
                    case "Image":
                        if let image = ImageView<R>(element: element, overrideStylesheet: _modifiers.overrideStylesheet ?? (_modifiers.stylesheet as! Stylesheet<R>)).body {
                            prev = prev + SwiftUI.Text(image)
                        }
                    default:
                        break
                    }
                case let .leaf(text):
                    prev = prev + SwiftUI.Text(text)
                case .root:
                    break
                }
            }
        }
    }
}

/// A style for formatting a date.
///
/// Possible values:
/// * `time`
/// * `date`
/// * `relative`
/// * `offset`
/// * `timer`
@_documentation(visibility: public)
extension SwiftUI.Text.DateStyle: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value else {
            throw AttributeDecodingError.missingAttribute(Self.self)
        }
        switch value {
        case "time":
            self = .time
        case "date":
            self = .date
        case "relative":
            self = .relative
        case "offset":
            self = .offset
        case "timer":
            self = .timer
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

/// A style for formatting a person's name.
///
/// Possible values:
/// * `short`
/// * `medium`
/// * `long`
/// * `abbreviated`
@_documentation(visibility: public)
extension PersonNameComponents.FormatStyle.Style: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value else {
            throw AttributeDecodingError.missingAttribute(Self.self)
        }
        switch value {
        case "short":
            self = .short
        case "medium":
            self = .medium
        case "long":
            self = .long
        case "abbreviated":
            self = .abbreviated
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
