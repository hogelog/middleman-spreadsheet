require "middleman-core"

Middleman::Extensions.register :spreadsheet do
  require "middleman/spreadsheet/extension"
  Middleman::Spreadsheet::Extension
end
