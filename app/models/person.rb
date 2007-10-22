class Person < ActiveRecord::Base
  belongs_to :location
  has_many :memos
  has_many :interested_people
  has_many :bbs_memos, :through => :interested_people
end
