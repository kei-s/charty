module Charty
  class Table
    def self.new(obj, **kwargs)
      case
      when defined?(Numo::NArray) && obj.kind_of?(Numo::NArray)
        require 'charty/table_adapters/narray_adapter'
        TableAdapters::NArrayAdapter.new(obj, **kwargs)
      when obj.respond_to?(:to_charty_table)
        obj.to_charty_table(**kwargs)
      else
        raise ArgumentError, "unsupported object: #{obj.inspect}"
      end
    end

    def initialize(columns:)
      @columns = Array(columns)
    end

    attr_reader :columns

    def to_html
      s = <<-HTML
<table>
  <thead>
    <tr>
      <th>No.</th>
      HTML
      columns.each do |col_name|
        s << <<-HTML
      <th>#{col_name}</th>
        HTML
      end
      s << <<-HTML
    </tr>
  </thead>
  <tbody>
      HTML
      each_row.with_index do |row, i|
        s << <<-HTML
    <tr>
      <td>#{i}</td>
        HTML
        j = 0
        while j < n_columns
          s << <<-HTML
      <td>#{row[j]}</td>
          HTML
          j += 1
        end
        s << <<-HTML
    </tr>
        HTML
      end
      s << <<-HTML
  </tbody>
</table>
      HTML
    end
  end
end
