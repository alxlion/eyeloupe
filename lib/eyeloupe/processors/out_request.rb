# frozen_string_literal: true

module Eyeloupe
  module Processors
    class OutRequest
      include Singleton

      attr_accessor :request, :body, :req_headers, :res_headers, :response, :started_at

      def initialize
        @request = nil
        @body = ""
        @req_headers = {}
        @res_headers = {}
        @started_at = nil
        @response = nil
      end

      def init(request, body)
        @request = request
        @body = body
        @started_at = Time.now
      end

      def process(response)
        @response = response

        Eyeloupe::OutRequest.create(
          verb: @request.method,
          hostname: @request['host'],
          path: @request.path,
          status: @response.code,
          format: @response.content_type,
          duration: (Time.now - @started_at) * 1000,
          payload: @request.body,
          req_headers: (get_req_headers || {}).to_json,
          res_headers: (@response.header || {}).to_json,
          response: @response.body,
          )
        response
      end

      protected

      def get_req_headers
        headers = {}
        @request.each_header do |key, value|
          headers[key] = value
        end
        headers
      end


    end
  end
end
