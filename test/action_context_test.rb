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

  def test_context_method_adds_before_filter
    assert TestController.respond_to?(:context), "ActionContext does not extend a class method named context"
    tcb_class = Class.new do
      include ActionContext
      def self.before_filter(*args)
        @@test_args = args
      end
      context :gimble, /^\/path/, :only => [:index, :show]
    end
    tcb = tcb_class.new
    assert_equal tcb_class.class_variable_get('@@test_args'), [ [ { :only => [:index, :show] } ] ]
  end

end
