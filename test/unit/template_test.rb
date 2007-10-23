require File.dirname(__FILE__) + '/../test_helper'

class TemplateTest < Test::Unit::TestCase
  fixtures :templates

  def test_assert_color
    assert_kind_of(Template, templates(:one))

    assert_equal("#e4a59f", templates(:one).color)

    one = Template.update(1, :color => "hoge")
    assert(!one.valid?)
    one.color = "#ffeeaa"
    assert(one.valid?)
    assert(one.save)
  end
end
