class Location < ActiveRecord::Base
  has_many :people
  validates_color_format_of :color
end
