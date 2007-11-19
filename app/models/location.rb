class Location < ActiveRecord::Base
  has_many :people, :dependent => :nullify
  validates_color_format_of :color
end
