module TableHelper
  def generate_table(opts = {})
    TableBuilder.new(opts).generate
  end

  class TableBuilder
    include ActionView::Helpers::TagHelper
    include ActionView::Context
    def initialize(opts = {})
      @opts = opts
    end

    def generate
      content_tag :table, class: table_class do
        safe_join([
          table_header,
          table_body
        ])
      end
    end

    private

    def table_header
      return unless header = @opts[:header]
      content_tag :thead do
        table_row(true, header)
      end
    end

    def table_body
      return unless rows = @opts[:content]
      content_tag :tbody do
        safe_join(rows.map { |row| table_row(false, row) })
      end
    end

    def table_row(header, elements)
      return unless elements
      content_tag :tr do
        safe_join(elements.map { |e| table_cell(header, e) })
      end
    end

    def table_cell(header, element)
      tag_type = header ? :th : :td
      content_tag tag_type do
        element.to_s
      end
    end

    def table_class
      classes = ['table']
      classes << 'table-striped' if @opts[:striped]
      classes << 'js-datatable'  if @opts[:data_table]
      classes.join(' ')
    end
  end

end
