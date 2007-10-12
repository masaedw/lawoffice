class InterestedPerson < ActiveRecord::Base
  belongs_to :person
  belongs_to :bbs_memo
end
