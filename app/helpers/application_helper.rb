# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def span_class person, param
    "<span class=\"#{param}\">"+ h(person.__send__(param)) +"</span>"
  end

  def user_list location
    if location.listup
      "<ul>\n#{render :partial => 'locations/user', :collection => location.people}\n</ul>"
    else
      ""
    end
  end
end
