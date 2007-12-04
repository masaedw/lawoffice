class Memo < ActiveRecord::Base
  include Readable

  belongs_to :person
  belongs_to :template

  validates_color_format_of :color

  before_save :fix_time

  private

  def fix_time
    now = Time.now
    if !self.ctime
      self.ctime = now
    end

    self.mtime = now
  end
end
