class ApplicationComponent < ViewComponent::Base
  alias_method :original_form_with, :form_with

  def form_with(**args, &block)
    original_form_with(**args, builder: SimpleTeamFormBuilder, &block)
  end

  def merge_html_attrs(default, incoming)
    return default unless incoming

    combined = {}

    keys = [ *default.keys, *incoming.keys ].uniq

    keys.each do |k|
      combined[k] = if default.key?(k) && incoming.key?(k)
                      merge_type(default[k], incoming[k])
      elsif default.key?(k)
                      default[k]
      elsif incoming.key?(k)
                      incoming[k]
      end
    end

    combined
  end

  def merge_type(default, incoming)
    case default
    when ->(v) { v.is_a?(::Hash) }
      merge_html_attrs(default, incoming)
    when ->(v) { v.is_a?(::String) }
      [ default, incoming ].join(" ")
    when ->(v) { v.is_a?(::Array) }
      [ *default, *incoming ]
    when ->(v) { v.is_a?(::Integer) }
      incoming
    end
  end
end
