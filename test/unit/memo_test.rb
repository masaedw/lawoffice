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

    one = memos(:one)

    assert(!one.read?)
    one.read = true
    assert(one.save)
    assert(one.read?)
  end

  def test_assert_color
    assert_kind_of(Memo, memos(:one))

    assert_equal("#e4a59f", memos(:one).color)

    one = Memo.update(1, :color => "hoge")
    assert(!one.valid?)
    one.color = "#ffeeaa"
    assert(one.valid?)
    assert(one.save)
  end
end

