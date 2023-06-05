# frozen_string_literal: true
require 'singleton'

module Eyeloupe
  module Processors
    class InRequest

      include Singleton

      # @return [ActionDispatch::Request]
      attr_accessor :request

      # @return [Hash, nil]
      attr_accessor :env

      # @return [Integer, nil]
      attr_accessor :status

      # @return [Hash, nil]
      attr_accessor :headers

      # @return [String, nil, Rack::BodyProxy, ActionDispatch::Response]
      attr_accessor :response

      # @return [Hash]
      attr_accessor :timings

      # @return [Time, nil]
      attr_accessor :started_at

      # @return [Array]
      attr_accessor :subs

      # @return [Eyeloupe::Exception, nil]
      attr_accessor :ex

      def initialize
        @env = {}
        @request = ActionDispatch::Request.new(@env)
        @status = nil
        @headers = nil
        @response = nil
        @timings = {}
        @started_at = nil
        @subs = []
        @ex = nil
      end

      # @param [ActionDispatch::Request] request The request object
      # @param [Hash, nil] env Rack environment
      # @param [Integer, nil] status HTTP status code
      # @param [Hash, nil] headers HTTP headers
      # @param [String, nil] response HTTP response
      # @param [Eyeloupe::Exception, nil] ex The exception object persisted in db
      # @return [Eyeloupe::Processors::InRequest]
      def init(request, env, status, headers, response, ex)
        unsubscribe

        @request = request
        @env = env
        @status = status
        @headers = headers
        @response = response
        @ex = ex

        self
      end

      def start_timer
        @started_at = Time.now

        subscribe('process_action.action_controller') do |event|
          @timings[:controller_time] = event.duration
          @timings[:db_time] = event.payload[:db_runtime]
          @timings[:view_time] = event.payload[:view_runtime]
        end
      end

      # @return [Eyeloupe::InRequest]
      def process

        req = Eyeloupe::InRequest.create(
          verb: @request.request_method,
          hostname: @request.host,
          path: @env["REQUEST_URI"],
          controller: get_controller,
          status: @status,
          format: @request.format,
          duration: get_total_duration,
          db_duration: @timings[:db_time].present? ? @timings[:db_time].round : nil,
          view_duration: @timings[:view_time].present? ? @timings[:view_time].round : nil,
          ip: @request.ip,
          payload: @env['rack.input'].read,
          headers: @headers&.to_json,
          session: (@request.session || {}).to_json,
          response: get_response,
        )

        @ex.update(in_request_id: req.id) if @ex.present? && @ex.in_request_id.blank?
      end

      protected

      # @return [Float]
      def get_total_duration
        if @timings[:controller_time].present?
          @timings[:controller_time].round
        elsif @started_at.present?
          (Time.now - @started_at) * 1000
        else
          0.0
        end
      end

      # @return [String, nil]
      def get_response
        if @request.format.to_s =~ /html/
          "HTML content"
        elsif @response.is_a?(ActionDispatch::Response)
          @response.body
        elsif @response.is_a?(Rack::BodyProxy) && @response.respond_to?(:first)
          @response.first
        else
          @response
        end
      end

      # @return [String, nil]
      def get_controller
        if @request.controller_class.to_s =~ /PASS_NOT_FOUND/
          nil
        else
          "#{@request.controller_class.to_s}##{@request.path_parameters[:action]}"
        end
      end

      private

      # @param [String] event The event to subscribe to
      # @param [Proc] block The block to execute when the event is triggered
      # @yield [ActiveSupport::Notifications::Event] The event object
      def subscribe(event, &block)
        @subs << ActiveSupport::Notifications.subscribe(event) do |*args|
          block.call(ActiveSupport::Notifications::Event.new(*args))
        end
      end

      def unsubscribe
        @subs.each do |sub|
          ActiveSupport::Notifications.unsubscribe(sub)
        end
        @subs = []
      end

    end
  end
end
