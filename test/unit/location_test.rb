require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < Test::Unit::TestCase
  fixtures :locations, :people

  def test_association
    assert_kind_of(Location, locations(:location1))

    assert_equal(2, locations(:location1).people.size)
    assert_kind_of(Person, locations(:location1).people[0])
  end
end
