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

  def j string
    h(string).to_json
  end

  def row_group ips
    ips.group_by{|i| i.posy }.to_a.sort_by{|i| i[0] }.map{|i| i[1] }
  end

  def checked_group ips
    ips.sort_by{|i| [i.person.posy, i.person.posx]}.in_groups_of(3)
  end
end
