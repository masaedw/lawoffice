class BbsMemo < ActiveRecord::Base
  has_many :interested_people
  has_many :people, :through => :interested_people
  belongs_to :template

  validates_color_format_of :color
  before_save :validate_checked

  def self.num_of_need_check
    BbsMemo.count(:conditions => ["checked = ? AND (select count(*) from interested_people as ip where ip.bbs_memo_id = bbs_memos.id and ip.checked = ?) = 0", false, false])
  end

  private

  def validate_checked
    if self.checked && !self.interested_people.all?{|i| i.checked}
      self.checked = false
    end
  end
end
