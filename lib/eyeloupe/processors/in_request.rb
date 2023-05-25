# frozen_string_literal: true
require 'singleton'

module Eyeloupe
  module Processors
    class InRequest

      include Singleton

      attr_accessor :request, :env, :status, :headers, :response, :timings, :started_at, :subs

      def initialize
        @env = {}
        @request = ActionDispatch::Request.new(@env)
        @status = nil
        @headers = nil
        @response = nil
        @timings = {}
        @started_at = nil
        @subs = []
      end

      def init(request, env, status, headers, response)
        unsubscribe

        @request = request
        @env = env
        @status = status
        @headers = headers
        @response = response
      end

      def start_timer
        @started_at = Time.now

        subscribe('process_action.action_controller') do |event|
          @timings[:controller_time] = event.duration
          @timings[:db_time] = event.payload[:db_runtime]
          @timings[:view_time] = event.payload[:view_runtime]
        end
      end

      def process
        Eyeloupe::InRequest.create(
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
      end

      protected

      def get_total_duration
        if @timings[:controller_time].present?
          @timings[:controller_time].round
        elsif @started_at.present?
          (Time.now - @started_at) * 1000
        else
          0.0
        end
      end

      def get_response
        if @request.format.to_s =~ /html/
          "HTML content"
        elsif @response.is_a?(ActionDispatch::Response)
          @response.body
        elsif @response.is_a?(Rack::BodyProxy)
          @response.first
        else
          @response
        end
      end

      def get_controller
        if @request.controller_class.to_s =~ /PASS_NOT_FOUND/
          nil
        else
          "#{@request.controller_class.to_s}##{@request.path_parameters[:action]}"
        end
      end

      private

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
