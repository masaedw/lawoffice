class InterestedPerson < ActiveRecord::Base
  include Readable

  belongs_to :person
  belongs_to :bbs_memo

  before_save :read_check

  private

  def read_check
    if !self.checked && self.bbs_memo.checked
      self.bbs_memo.update_attribute(:checked, false)
    end
  end
end
