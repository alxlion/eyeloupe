# frozen_string_literal: true
require 'singleton'

module Eyeloupe
  class Configuration
    include Singleton

    attr_accessor :excluded_paths, :capture

    def initialize
      @excluded_paths = %w[]
      @capture = true
    end
  end

end