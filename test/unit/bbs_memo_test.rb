require File.dirname(__FILE__) + '/../test_helper'

class BbsMemoTest < Test::Unit::TestCase
  fixtures :bbs_memos, :templates, :interested_people, :people

  def test_association
    assert_kind_of(BbsMemo, bbs_memos(:one))

    assert_equal(5, bbs_memos(:one).interested_people.size)
    assert_kind_of(InterestedPerson, bbs_memos(:one).interested_people[0])
    assert_equal(5, bbs_memos(:one).people.size)
    assert_kind_of(Person, bbs_memos(:one).people[0])
  end

  def test_assert_color
    assert_kind_of(BbsMemo, bbs_memos(:one))

    assert_equal("#e4a59f", bbs_memos(:one).color)

    one = BbsMemo.update(1, :color => "hoge")
    assert(!one.valid?)
    one.color = "#ffeeaa"
    assert(one.valid?)
    assert(one.save)
  end
end
