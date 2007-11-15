module ElementID
  def element_id
    self.class.to_s.downcase+"_"+self.id.to_s
  end
end

ActiveRecord::Base.instance_eval { include ElementID }
