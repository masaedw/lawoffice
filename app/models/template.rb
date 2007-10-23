class Template < ActiveRecord::Base
  validates_color_format_of :color
end
