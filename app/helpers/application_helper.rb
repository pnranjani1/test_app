module ApplicationHelper
  include Rails.application.routes.url_helpers
def full_title(page_title)
  base_title = "OnWebAccount.in"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end
def root_detector()
  if current_page?(root_url)
    return true
  else
    return false
  end
end


  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(image_tag('button_cancel_256.png'), "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("shared/"+association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, ("add_fields(this,\"#{association}\",\"#{escape_javascript(fields)}\")"), class: "btn btn-info")
  end

end
