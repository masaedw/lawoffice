require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < Test::Unit::TestCase
  fixtures :locations, :people

  def test_association
    assert_kind_of(Location, locations(:location1))

    assert_equal(1, locations(:location1).people.size)
    assert_kind_of(Person, locations(:location1).people[0])
  end

  def test_association2
    user2 = people(:user2)

    assert_equal(user2.location, locations(:location2))

    location2_people_size = locations(:location2).people.size
    user2.location = locations(:location1)
    user2.save!

    assert_equal(2, locations(:location1).people.size)
    assert_equal(location2_people_size-1, locations(:location2).people.size)
  end

  def test_association2
    location3 = locations(:location3)

    assert_equal(3, location3.people.size)
    assert_equal(people(:user4).location, location3)
    assert_equal(people(:user5).location, location3)
    assert_equal(people(:user6).location, location3)

    location3.destroy

    assert_equal(people(:user4).reload.location, nil)
    assert_equal(people(:user5).reload.location, nil)
    assert_equal(people(:user6).reload.location, nil)
  end
end
