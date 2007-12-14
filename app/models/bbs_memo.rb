class BbsMemo < ActiveRecord::Base
  has_many :interested_people
  has_many :people, :through => :interested_people
  belongs_to :template

  validates_color_format_of :color
  before_save :validate_checked

  private

  def validate_checked
    if self.checked && !self.interested_people.all?{|i| i.checked}
      self.checked = false
    end
  end
end
