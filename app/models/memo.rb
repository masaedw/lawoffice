class Memo < ActiveRecord::Base
  belongs_to :person
  belongs_to :template
end
