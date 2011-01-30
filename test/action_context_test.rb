require 'helper'
require 'action_context'

class ActionContextTest < Test::Unit::TestCase

  class TestController
    include ActionContext
  end

  def test_set_and_match_context_methods
    tc = TestController.new
    tc.set_context(:primary, /^\/users/)
    tc.set_context(:secondary, /^\/pages/)
    assert tc.match_context(:primary, "/users")
    assert tc.match_context(:secondary, "/pages/123/edit")
    assert !tc.match_context(:secondary, "/users")
    assert !tc.match_context(:doesntexist, "/qwerty")
  end

end
