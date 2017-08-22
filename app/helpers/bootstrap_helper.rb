module BootstrapHelper
  def col_sizes(params={})
    offsets = params.delete(:offset) || {}
    cols = params.to_a.map do |pair|
      "col-#{pair[0]}-#{pair[1]}"
    end.join(' ')

    offsets = offsets.to_a.map do |pair|
      "offset-#{pair[0]}-#{pair[1]}"
    end.join(' ')

    {tag: 'div', class: "#{cols} #{offsets}"}
  end

  def vertical_form_for(record, options={}, &block)
    options.merge! builder: VerticalFormBuilder
    form_for record, options, &block
  end
end
