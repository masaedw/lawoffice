module LocationsHelper
  def user_list location
    if location.listup
      "<ul>\n#{render :partial => 'user', :collection => location.people}\n</ul>"
    else
      ""
    end
  end
end
