class Person < ActiveRecord::Base
  belongs_to :location
  has_many :memos
  has_many :interested_people, :dependent => :destroy
  has_many :bbs_memos, :through => :interested_people
  order_by :fields => ['posy', 'posx']

  def bgcolor
    location ? location.color : "#eceef0"
  end

  def left
    posx
  end

  def top
    posy
  end

  def unread
    memos.count(:conditions => ["checked = ?", false])
  end

  def bbs_unread
    interested_people.count(:conditions => ["checked = ?", false])
  end

  def all_unread
    unread + bbs_unread
  end

  def is_destination_of memo
    InterestedPerson.count(:conditions => ["person_id = ? AND bbs_memo_id = ?", self.id, memo.id]) > 0
  end
end
