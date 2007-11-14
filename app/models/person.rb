class Person < ActiveRecord::Base
  belongs_to :location
  has_many :memos
  has_many :interested_people
  has_many :bbs_memos, :through => :interested_people

  def bgcolor
    location.color
  end

  def left
    posx
  end

  def top
    posy
  end

  def unread
    memos.count(:all, :conditions => ["read = ?", false])
  end
end
