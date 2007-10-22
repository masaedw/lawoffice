module Readable
  def read?
    self.read == true
  end

  def read!
    self.read = true
    save!
  end
end
