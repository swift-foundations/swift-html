//
//  HTML.ElementTypealiases.swift
//  swift-html
//
//  Lowercase typealiases for HTML elements providing a more HTML-like syntax.
//

import CSS
import CSS_Standard
import HTML_Standard

/// Lowercase typealias for creating Anchor elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `anchor` identifier when creating
/// HTML anchor elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// anchor(href: "https://example.com") {
///     "Visit Example Website"
/// }
/// ```
public typealias a = HTML.Anchor.Element

/// Lowercase typealias for creating Abbreviation elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `abbr` identifier when creating
/// HTML abbreviation elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// abbr {
///     "HTML"
/// }
/// ```
public typealias abbr = HTML.Abbreviation.Element

/// Lowercase typealias for creating Address elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `address` identifier when creating
/// HTML address elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// address {
///   "Contact us: contact@example.com"
/// }
/// ```
public typealias address = HTML.Address.Element

/// Lowercase typealias for creating Area elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `area` identifier when creating
/// HTML area elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// area(
///   shape: .circle(coords: "75,75,75"),
///   href: "section.html",
///   alt: "Go to section"
/// )
/// ```
public typealias area = HTML.Area.Element

/// Lowercase typealias for creating Article elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `article` identifier when creating
/// HTML article elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// article {
///   heading2 { "Blog Post Title" }
///   HTMLComponents.Paragraph { "Content goes here..." }
/// }
/// ```
public typealias article = HTML.Article.Element

/// Lowercase typealias for creating Aside elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `aside` identifier when creating
/// HTML aside elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// aside {
///   HTMLComponents.Paragraph { "This is supplementary information that enhances the main content." }
/// }
/// ```
public typealias aside = HTML.Aside.Element

/// Lowercase typealias for creating Audio elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `audio` identifier when creating
/// HTML audio elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// audio(controls: true) {
///     source(src: "audio.mp3", type: "audio/mpeg")
///     "Your browser does not support the audio element."
/// }
/// ```
public typealias audio = HTML.Audio.Element

/// Lowercase typealias for creating B elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `b` identifier when creating
/// HTML b elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// b {
///     "This text is bold but semantically neutral."
/// }
/// ```
public typealias b = HTML.B.Element

/// Lowercase typealias for creating Base elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `base` identifier when creating
/// HTML base elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// base(href: "https://example.com/")
/// ```
public typealias base = HTML.Base.Element

/// Lowercase typealias for creating Body elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `body` identifier when creating
/// HTML body elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// body {
///   heading1 { "Welcome to My Website" }
///   HTMLComponents.Paragraph { "This is the content of my webpage." }
/// }
/// ```
public typealias body = HTML.Body.Element

/// Lowercase typealias for creating BidirectionalIsolate elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `bdi` identifier when creating
/// HTML bidirectional isolate elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// bdi {
///     "User-generated content with possibly different directionality"
/// }
/// ```
public typealias bdi = HTML.BidirectionalIsolate.Element

/// Lowercase typealias for creating BidirectionalTextOverride elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `bdo` identifier when creating
/// HTML bidirectional text override elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// bdo(dir: .rtl) {
///     "This text will display right-to-left."
/// }
/// ```
public typealias bdo = HTML.BidirectionalTextOverride.Element

/// Lowercase typealias for creating Big elements with a more HTML-like syntax.
public typealias big = HTML.Big.Element

/// Lowercase typealias for creating BlockQuote elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `blockquote` identifier when creating
/// HTML block quotation elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// blockquote(cite: "https://www.example.com/source") {
///     p {
///         "This is a block quotation with a citation source."
///     }
/// }
/// ```
public typealias blockquote = HTML.BlockQuote.Element

/// Lowercase typealias for creating BR elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `br` identifier when creating
/// HTML br elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// p {
///     "First line"
///     br()
///     "Second line"
/// }
/// ```
public typealias br = HTML.BR.Element

/// Lowercase typealias for creating Button elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `button` identifier when creating
/// HTML button elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// button {
///     "Click me"
/// }
/// ```
public typealias button = HTML.Button.Element

/// Lowercase typealias for creating Canvas elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `canvas` identifier when creating
/// HTML canvas elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// canvas(width: 300, height: 150) {
///     "Your browser does not support the canvas element."
/// }
/// ```
public typealias canvas = HTML.Canvas.Element

/// Lowercase typealias for creating Caption elements with a more HTML-like syntax.
public typealias caption = HTML.Caption.Element

/// Lowercase typealias for creating Center elements with a more HTML-like syntax.
public typealias center = HTML.Center.Element

/// Lowercase typealias for creating Citation elements with a more HTML-like syntax.
public typealias cite = HTML.Cite.Element

/// Lowercase typealias for creating Code elements with a more HTML-like syntax.
public typealias code = HTML.Code.Element

/// Lowercase typealias for creating TableColumn elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `col` identifier when creating
/// HTML column elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// col(span: 2, width: "100px")
/// ```
public typealias col = HTML.TableColumn.Element

/// Lowercase typealias for creating TableColumnGroup elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `colgroup` identifier when creating
/// HTML column group elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// colgroup(span: 5, class: "weekdays")
/// ```
/// Or:
/// ```swift
/// colgroup {
///   col()
///   col(span: 2)
/// }
/// ```
public typealias colgroup = HTML.TableColumnGroup.Element

/// Lowercase typealias for creating Data elements with a more HTML-like syntax.
public typealias data = HTML.Data.Element

/// Lowercase typealias for creating DataList elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `datalist` identifier when creating
/// HTML datalist elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// datalist(id: "browsers") {
///     option(value: "Chrome")
///     option(value: "Firefox")
///     option(value: "Safari")
/// }
/// ```
public typealias datalist = HTML.DataList.Element

/// Lowercase typealias for creating DescriptionDetails elements with a more HTML-like syntax.
public typealias dd = HTML.DescriptionDetails.Element

/// Lowercase typealias for creating Del elements with a more HTML-like syntax.
public typealias del = HTML.Del.Element

/// Lowercase typealias for creating Details elements with a more HTML-like syntax.
public typealias details = HTML.Details.Element

/// Lowercase typealias for creating Definition elements with a more HTML-like syntax.
public typealias dfn = HTML.Definition.Element

/// Lowercase typealias for creating Dialog elements with a more HTML-like syntax.
public typealias dialog = HTML.Dialog.Element

/// Lowercase typealias for creating Directory elements with a more HTML-like syntax.
public typealias dir = HTML.Directory.Element

/// Lowercase typealias for creating ContentDivision elements with a more HTML-like syntax.
public typealias div = HTML.ContentDivision.Element

/// Lowercase typealias for creating Description List elements with a more HTML-like syntax.
public typealias dl = HTML.DescriptionList.Element

/// Lowercase typealias for creating DescriptionTerm elements with a more HTML-like syntax.
public typealias dt = HTML.DescriptionTerm.Element

/// Lowercase typealias for creating Emphasis elements with a more HTML-like syntax.
public typealias em = HTML.Emphasis.Element

/// Lowercase typealias for creating Embed elements with a more HTML-like syntax.
public typealias embed = HTML.Embed.Element

/// Lowercase typealias for creating FencedFrame elements with a more HTML-like syntax.
public typealias fencedframe = HTML.FencedFrame.Element

/// Lowercase typealias for creating FieldSet elements with a more HTML-like syntax.
public typealias fieldset = HTML.FieldSet.Element

/// Lowercase typealias for creating FigureCaption elements with a more HTML-like syntax.
public typealias figcaption = HTML.FigureCaption.Element

/// Lowercase typealias for creating Figure elements with a more HTML-like syntax.
public typealias figure = HTML.Figure.Element

/// Lowercase typealias for creating Font elements with a more HTML-like syntax.
public typealias font = HTML.Font.Element

/// Lowercase typealias for creating Footer elements with a more HTML-like syntax.
public typealias footer = HTML.Footer.Element

/// Lowercase typealias for creating Form elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `form` identifier when creating
/// HTML form elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// form(name: "login", action: "/login", method: .post) {
///     // Form controls
/// }
/// ```
public typealias form = HTML.Form.Element

/// Lowercase typealias for creating Frame elements with a more HTML-like syntax.
public typealias frame = HTML.Frame.Element

/// Lowercase typealias for creating Frameset elements with a more HTML-like syntax.
public typealias frameset = HTML.Frameset.Element

public typealias h1 = HTML.H1.Element
public typealias h2 = HTML.H2.Element
public typealias h3 = HTML.H3.Element
public typealias h4 = HTML.H4.Element
public typealias h5 = HTML.H5.Element
public typealias h6 = HTML.H6.Element

/// Lowercase typealias for creating Head elements with a more HTML-like syntax.
public typealias head = HTML.Head.Element

/// Lowercase typealias for creating Header elements with a more HTML-like syntax.
public typealias header = HTML.Header.Element

/// Lowercase typealias for creating HeadingGroup elements with a more HTML-like syntax.
public typealias hgroup = HTML.HeadingGroup.Element

/// Lowercase typealias for creating ThematicBreak elements with a more HTML-like syntax.
public typealias hr = HTML.ThematicBreak.Element

/// Lowercase typealias for creating HtmlRoot elements with a more HTML-like syntax.
public typealias html = HTML.HtmlRoot.Element

/// Lowercase typealias for creating IdiomaticText elements with a more HTML-like syntax.
public typealias i = HTML.IdiomaticText.Element

/// Lowercase typealias for creating InlineFrame elements with a more HTML-like syntax.
public typealias iframe = HTML.InlineFrame.Element

public typealias img = HTML.Image.Element

/// Lowercase typealias for creating Input elements with a more HTML-like syntax.
/// Example: `input(name: "username", disabled: nil, type: .text(...))`
public typealias input = HTML.Input.Element

/// Lowercase typealias for creating InsertedText elements with a more HTML-like syntax.
public typealias ins = HTML.InsertedText.Element

/// Lowercase typealias for creating KeyboardInput elements with a more HTML-like syntax.
public typealias kbd = HTML.KeyboardInput.Element

/// Lowercase typealias for creating Label elements with a more HTML-like syntax.
///
/// Example: `label(for: "name") { "Your name:" }`
public typealias label = HTML.Label.Element

/// Lowercase typealias for creating Legend elements with a more HTML-like syntax.
public typealias legend = HTML.Legend.Element

/// Lowercase typealias for creating ListItem elements with a more HTML-like syntax.
public typealias li = HTML.ListItem.Element

/// Lowercase typealias for creating Link elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `link` identifier when creating
/// HTML link elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// link(href: "styles.css", rel: "stylesheet")
/// ```
public typealias link = HTML.Link.Element

/// Lowercase typealias for creating Main elements with a more HTML-like syntax.
public typealias main = HTML.Main.Element

/// Lowercase typealias for creating Map elements with a more HTML-like syntax.
public typealias map = HTML.Map.Element

/// Lowercase typealias for creating Mark elements with a more HTML-like syntax.
public typealias mark = HTML.Mark.Element

/// Lowercase typealias for creating Marquee elements with a more HTML-like syntax.
public typealias marquee = HTML.Marquee.Element

/// Lowercase typealias for creating Menu elements with a more HTML-like syntax.
public typealias menu = HTML.Menu.Element

/// Lowercase typealias for creating Meta elements with a more HTML-like syntax.
///
/// This typealias allows you to use the lowercase `meta` identifier when creating
/// HTML meta elements, which more closely matches HTML syntax.
///
/// Example:
/// ```swift
/// meta(name: .description, content: "Page description")
/// ```
public typealias meta = HTML.Meta.Element

/// Lowercase typealias for creating Meter elements with a more HTML-like syntax.
public typealias meter = HTML.Meter.Element

/// Lowercase typealias for creating NavigationSection elements with a more HTML-like syntax.
public typealias nav = HTML.NavigationSection.Element

/// Lowercase typealias for creating NoBr elements with a more HTML-like syntax.
public typealias nobr = HTML.NoBr.Element

/// Lowercase typealias for creating EmbedFallback elements with a more HTML-like syntax.
public typealias noembed = HTML.EmbedFallback.Element

/// Lowercase typealias for creating FrameFallback elements with a more HTML-like syntax.
@available(
    *,
    deprecated,
    message: "The noframes element is obsolete and shouldn't be used in modern web development"
)
public typealias noframes = HTML.FrameFallback.Element

/// Lowercase typealias for creating Noscript elements with a more HTML-like syntax.
public typealias noscript = HTML.Noscript.Element

/// Lowercase typealias for creating Object elements with a more HTML-like syntax.
public typealias object = HTML.ExternalObject.Element

/// Lowercase typealias for creating OrderedList elements with a more HTML-like syntax.
public typealias ol = HTML.OrderedList.Element

/// Lowercase typealias for creating OptionGroup elements with a more HTML-like syntax.
public typealias optgroup = HTML.OptionGroup.Element

/// Lowercase typealias for creating Option elements with a more HTML-like syntax.
public typealias option = HTML.Option.Element

/// Lowercase typealias for creating Output elements with a more HTML-like syntax.
public typealias output = HTML.Output.Element

/// Lowercase typealias for creating Paragraph elements with a more HTML-like syntax.
public typealias p = HTML.Paragraph.Element

/// Lowercase typealias for creating Param elements with a more HTML-like syntax.
public typealias param = HTML.Param.Element

/// Lowercase typealias for creating Picture elements with a more HTML-like syntax.
public typealias picture = HTML.Picture.Element

/// Lowercase typealias for creating PlainText elements with a more HTML-like syntax.
@available(
    *,
    deprecated,
    message: "The <plaintext> element is deprecated. Use <pre> or <code> instead."
)
public typealias plaintext = HTML.PlainText.Element

/// Lowercase typealias for creating PreformattedText elements with a more HTML-like syntax.
public typealias pre = HTML.PreformattedText.Element

/// Lowercase typealias for creating ProgressIndicator elements with a more HTML-like syntax.
public typealias progress = HTML.ProgressIndicator.Element

/// Lowercase typealias for creating InlineQuotation elements with a more HTML-like syntax.
public typealias q = HTML.InlineQuotation.Element

/// Lowercase typealias for creating RubyBase elements with a more HTML-like syntax.
public typealias rb = HTML.RubyBase.Element

/// Lowercase typealias for creating RubyParenthesis elements with a more HTML-like syntax.
public typealias rp = HTML.RubyParenthesis.Element

/// Lowercase typealias for creating RubyText elements with a more HTML-like syntax.
public typealias rt = HTML.RubyText.Element

/// Lowercase typealias for creating RubyTextContainer elements with a more HTML-like syntax.
public typealias rtc = HTML.RubyTextContainer.Element

/// Lowercase typealias for creating Ruby elements with a more HTML-like syntax.
public typealias ruby = HTML.Ruby.Element

/// Lowercase typealias for creating Strikethrough elements with a more HTML-like syntax.
public typealias s = HTML.Strikethrough.Element

/// Lowercase typealias for creating Sample Output elements with a more HTML-like syntax.
public typealias samp = HTML.Samp.Element

/// Lowercase typealias for creating Script elements with a more HTML-like syntax.
public typealias script = HTML.Script.Element

/// Lowercase typealias for creating Search elements with a more HTML-like syntax.
public typealias search = HTML.Search.Element

/// Lowercase typealias for creating Section elements with a more HTML-like syntax.
public typealias section = HTML.Section.Element

/// Lowercase typealias for creating Select elements with a more HTML-like syntax.
public typealias select = HTML.Select.Element

/// Lowercase typealias for creating WebComponentSlot elements with a more HTML-like syntax.
public typealias slot = HTML.WebComponentSlot.Element

/// Lowercase typealias for creating Small elements with a more HTML-like syntax.
public typealias small = HTML.Small.Element

/// Lowercase typealias for creating Source elements with a more HTML-like syntax.
public typealias source = HTML.Source.Element

/// Lowercase typealias for creating span elements with a more HTML-like syntax.
public typealias span = HTML.ContentSpan.Element

/// Lowercase typealias for creating Strike elements with a more HTML-like syntax.
public typealias strike = HTML.Strike.Element

/// Lowercase typealias for creating StrongImportance elements with a more HTML-like syntax.
public typealias strong = HTML.StrongImportance.Element

/// Lowercase typealias for creating Style elements with a more HTML-like syntax.
public typealias style = HTML.Style.Element

/// Lowercase typealias for creating Subscript elements with a more HTML-like syntax.
public typealias sub = HTML.Subscript.Element

/// Lowercase typealias for creating DisclosureSummary elements with a more HTML-like syntax.
public typealias summary = HTML.DisclosureSummary.Element

/// Lowercase typealias for creating Superscript elements with a more HTML-like syntax.
public typealias sup = HTML.Superscript.Element

/// Lowercase typealias for creating Table elements with a more HTML-like syntax.
public typealias table = HTML.Table.Element

/// Lowercase typealias for creating TableBody elements with a more HTML-like syntax.
public typealias tbody = HTML.TableBody.Element

/// Lowercase typealias for creating TableDataCell elements with a more HTML-like syntax.
public typealias td = HTML.TableDataCell.Element

/// Lowercase typealias for creating ContentTemplate elements with a more HTML-like syntax.
public typealias template = HTML.ContentTemplate.Element

/// Lowercase typealias for creating Textarea elements with a more HTML-like syntax.
public typealias textarea = HTML.Textarea.Element

/// Lowercase typealias for creating TableFoot elements with a more HTML-like syntax.
public typealias tfoot = HTML.TableFoot.Element

/// Lowercase typealias for creating TableHeader elements with a more HTML-like syntax.
public typealias th = HTML.TableHeader.Element

/// Lowercase typealias for creating TableHead elements with a more HTML-like syntax.
public typealias thead = HTML.TableHead.Element

/// Lowercase typealias for creating Time elements with a more HTML-like syntax.
public typealias time = HTML.Time.Element

/// Lowercase typealias for creating Title elements with a more HTML-like syntax.
public typealias title = HTML.Title.Element

/// Lowercase typealias for creating TableRow elements with a more HTML-like syntax.
public typealias tr = HTML.TableRow.Element

/// Lowercase typealias for creating Track elements with a more HTML-like syntax.
public typealias track = HTML.Track.Element

/// Lowercase typealias for creating TeletypeText elements with a more HTML-like syntax.
public typealias tt = HTML.TeletypeText.Element

/// Lowercase typealias for creating UnarticulatedAnnotation elements with a more HTML-like syntax.
public typealias u = HTML.UnarticulatedAnnotation.Element

/// Alternative lowercase typealias for creating UnarticulatedAnnotation elements.
public typealias underline = HTML.UnarticulatedAnnotation.Element

/// Lowercase typealias for creating UnorderedList elements with a more HTML-like syntax.
public typealias ul = HTML.UnorderedList.Element

/// Lowercase typealias for creating Variable elements with a more HTML-like syntax.
/// Note: Backticks are required since `var` is a reserved keyword in Swift.
public typealias `var` = HTML.Variable.Element

/// Lowercase typealias for creating Video elements with a more HTML-like syntax.
public typealias video = HTML.Video.Element

/// Lowercase typealias for creating LineBreakOpportunity elements with a more HTML-like syntax.
public typealias wbr = HTML.LineBreakOpportunity.Element
