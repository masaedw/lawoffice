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

  def test_bgcolor
    user1 = people(:user1)
    assert_equal("#eedddd", user1.location.color)
    assert_equal(user1.location.color, user1.bgcolor)
  end

  def test_position
    user1 = people(:user1)

    assert_equal(300, user1.posx)
    assert_equal(user1.posx, user1.left)

    assert_equal(100, user1.posy)
    assert_equal(user1.posy, user1.top)
  end

  def test_unread
    user1 = people(:user1)

    assert_equal(false, user1.memos[0].checked)
    assert_equal(false, user1.memos[1].checked)

    assert_equal(2, user1.unread)
  end
end
