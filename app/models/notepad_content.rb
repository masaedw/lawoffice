class NotepadContent < ActiveRecord::Base
  def self.get
    NotepadContent.find(1).body
  end

  def self.set value
    content = NotepadContent.find(1)
    content.body = value
    content.save
  end
end
