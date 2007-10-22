class Memo < ActiveRecord::Base
  include Readable

  belongs_to :person
  belongs_to :template
end
