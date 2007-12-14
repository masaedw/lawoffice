class Person < ActiveRecord::Base
  belongs_to :location
  has_many :memos
  has_many :interested_people
  has_many :bbs_memos, :through => :interested_people

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
    if @unread
      @unread
    else
      @unread = memos.count(:all, :conditions => ["checked = ?", false])
    end
  end

  def bbs_unread
    if @bbs_unread
      @bbs_unread
    else
      @bbs_unread = interested_people.count(:all, :conditions => ["checked = ?", false])
    end
  end

  def is_destination_of memo
    InterestedPerson.count(:conditions => ["person_id = ? AND bbs_memo_id = ?", self.id, memo.id]) > 0
  end
end
