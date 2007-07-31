require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  fixtures :people, :locations

  def test_association
    assert_kind_of(Person, people(:user1))

    assert_kind_of(Location, people(:user1).location)
  end
end
