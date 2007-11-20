require File.dirname(__FILE__) + '/../test_helper'

# memo{1..5}, people{1..6}
# 1  1 2 3 4 5
# 2    2 3   5 6
# 3    2 3 4 5 6  checked
# 4  1 2 3
# 5      3 4 5    checked


class InterestedPersonTest < Test::Unit::TestCase
  fixtures :interested_people, :bbs_memos, :people

  def test_association
    assert_kind_of(InterestedPerson, interested_people(:interested_person_1))

    assert_kind_of(Person, interested_people(:interested_person_1).person)
    assert_kind_of(BbsMemo, interested_people(:interested_person_1).bbs_memo)
  end

  def test_checked
    assert_kind_of(InterestedPerson, interested_people(:interested_person_1))

    assoc1 = interested_people(:interested_person_1)

    assert(!assoc1.checked?)
    assoc1.checked = true
    assert(assoc1.save)
    assert(assoc1.checked?)
  end
end
