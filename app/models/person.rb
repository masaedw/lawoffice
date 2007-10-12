class Person < ActiveRecord::Base
  belongs_to :location
  has_many :interested_person
  has_many :bbs_memo, :through => :interested_person
end
