# frozen_string_literal: true
require 'singleton'

module Eyeloupe
  class Configuration
    include Singleton

    # @return [Array<String>]
    attr_accessor :excluded_paths

    # @return [Boolean]
    attr_accessor :capture

    def initialize
      @excluded_paths = %w[]
      @capture = true
    end
  end

end