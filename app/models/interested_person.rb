class InterestedPerson < ActiveRecord::Base
  include Readable

  belongs_to :person
  belongs_to :bbs_memo
end
