require 'active_support/core_ext'

module ActionContext
  extend ActiveSupport::Concern

  module ClassMethods

    # Sugar to wrap set_context within before_filter
    def context(context, matcher, *args)
      before_filter(args) do
        set_context(context, matcher)
      end
    end

  end

  module InstanceMethods
    
    # Establish a connection between the current action and where we are in the current navigation context.
    # Accepts a context symbol (e.g. :primary) and a Regex matcher (e.g. /^\/users/).
    def set_context(context, matcher)
      @contexts ||= {}
      @contexts[context] = matcher
    end
  
    # Checks the given path to see if it represents the specified context
    def match_context(context, path)
      @contexts ||= {}
      return false unless @contexts[context].present?
      return true if path =~ @contexts[context]
      false
    end

  end

end
