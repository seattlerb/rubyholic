module ApplicationHelper

  RUBYHOLIC_VERSION = "1.0 beta" unless defined? RUBYHOLIC_VERSION

  def form_field(type, model, column, legend, options={})
    label = %(<th><label for="#{model}_#{column}">#{legend}</label></th>)
    field = %(<td>#{send "#{type}_field", model, column, options}</td>)
    return ['<tr>', label, field, '</tr>'].join("\n")
  end
  
  def header
    %(<span class="header"><a href="http://www.rubyholic.com/">[Home]</a></span>)
  end
  
  def footer
    %(<p class="footer"><a href="http://www.rubyholic.com/">Rubyholic.com</a>, version #{RUBYHOLIC_VERSION}</p>)
  end
end
