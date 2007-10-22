require File.dirname(__FILE__) + '/../test_helper'

class MemoTest < Test::Unit::TestCase
  fixtures :memos, :people, :templates

  def test_association
    assert_kind_of(Memo, memos(:one))

    assert_kind_of(Person, memos(:one).person)
    assert_kind_of(Template, memos(:one).template)
  end

  def test_read
    assert_kind_of(Memo, memos(:one))

    assert(!memos(:one).read?)
    memos(:one).read!
    assert(memos(:one).read?)
  end
end
