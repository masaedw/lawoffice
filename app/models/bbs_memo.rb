class BBSMemo < ActiveRecord::Base
  has_many :interested_person
  belongs_to :template
end
