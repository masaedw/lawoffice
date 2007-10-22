require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  fixtures :people, :locations, :memos, :bbs_memos, :interested_people

  def test_association_location
    assert_kind_of(Person, people(:user1))

    assert_kind_of(Location, people(:user1).location)
  end

  def test_association_memo
    assert_kind_of(Person, people(:user1))

    assert_equal(2, people(:user1).memos.size)
    assert_kind_of(Memo, people(:user1).memos[0])
  end

  def test_association_bbs_memo
    assert_kind_of(Person, people(:user1))

    assert_equal(2, people(:user1).interested_people.size)
    assert_equal(people(:user1).interested_people.size, people(:user1).bbs_memos.size)

    assert_kind_of(InterestedPerson, people(:user1).interested_people[0])
    assert_kind_of(BbsMemo, people(:user1).bbs_memos[0])
  end
end
