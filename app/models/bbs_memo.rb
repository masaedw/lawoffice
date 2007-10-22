class BbsMemo < ActiveRecord::Base
  has_many :interested_people
  has_many :people, :through => :interested_people
  belongs_to :template
end
