class Memo < ActiveRecord::Base
  include Readable

  belongs_to :person
  belongs_to :template

  validates_color_format_of :color
end
