require "middleman-core"

Middleman::Extensions.register :middleman-spreadsheet do
  require "my-extension/extension"
  MyExtension
end
