module ApplicationHelper
  def form_field(type, model, column, legend, options={})
    label = %(<th><label for="#{model}_#{column}">#{legend}</label></th>)
    field = %(<td>#{send "#{type}_field", model, column, options}</td>)
    return ['<tr>', label, field, '</tr>'].join("\n")
  end

  def my_stylesheet_link_tag(*args)
    stylesheet_link_tag(*args).sub(/\/>/, '>')
  end
end
