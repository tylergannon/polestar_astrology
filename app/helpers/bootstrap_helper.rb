module BootstrapHelper
  def col_sizes(params={})
    offsets = params.delete(:offset) || {}
    cols = params.to_a.map do |pair|
      if pair[0] == :xs
        "col-#{pair[1]}"
      else
        "col-#{pair[0]}-#{pair[1]}"
      end
    end.join(' ')

    offsets = offsets.to_a.map do |pair|
      if pair[0] == :xs
        "offset-#{pair[1]}"
      else
        "offset-#{pair[0]}-#{pair[1]}"
      end
    end.join(' ')

    {tag: 'div', class: "#{cols} #{offsets}"}
  end

  def vertical_form_for(record, options={}, &block)
    options.merge! builder: VerticalFormBuilder
    form_for record, options, &block
  end
end
