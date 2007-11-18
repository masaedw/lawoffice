# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def span_class person, param
    "<span class=\"#{param}\">"+ h(person.__send__(param)) +"</span>"
  end
end
