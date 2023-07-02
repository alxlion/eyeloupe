# frozen_string_literal: true
require 'singleton'

module Eyeloupe
  class Configuration
    include Singleton

    # @return [Symbol|Nil]
    attr_accessor :database

    # @return [Array<String>]
    attr_accessor :excluded_paths

    # @return [Boolean]
    attr_accessor :capture

    # @return [String]
    attr_accessor :openai_access_key

    # @return [String]
    attr_accessor :openai_model

    def initialize
      @excluded_paths = %w[]
      @capture = true
      @openai_model = "gpt-3.5-turbo"
    end
  end

end
