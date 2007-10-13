class BbsMemo < ActiveRecord::Base
  has_many :interested_person
  has_many :person, :through => :interested_person
  belongs_to :template
end
