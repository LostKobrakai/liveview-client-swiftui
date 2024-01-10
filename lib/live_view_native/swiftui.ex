defmodule LiveViewNative.SwiftUI do
  use LiveViewNative,
    format: :swiftui,
    component: LiveViewNative.SwiftUI.Component,
    module_suffix: :SwiftUI,
    tag_handler: LiveViewNative.TagEngine,
    template_engine: LiveViewNative.Engine,
    stylesheet_rules_parser: LiveViewNative.SwiftUI.RulesParser
end
