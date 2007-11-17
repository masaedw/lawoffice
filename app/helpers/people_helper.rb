module PeopleHelper
  def span_class person, param
    "<span class=\"#{param}\">"+ h(person.__send__(param)) +"</span>"
  end
end
