# frozen_string_literal: true

module Eyeloupe
  module Processors
    class OutRequest
      include Singleton

      # @return [Net::HTTPRequest, nil]
      attr_accessor :request

      # @return [String]
      attr_accessor :body

      # @return [Time, nil]
      attr_accessor :started_at

      def initialize
        @request = nil
        @body = ""
        @started_at = nil
      end

      # @param [Net::HTTPRequest] request The request object
      # @param [String] body The request body
      def init(request, body)
        @request = request
        @body = body
        @started_at = Time.now
      end

      # @param [Net::HTTPResponse] response The response object
      # @param [Eyeloupe::Exception, nil] ex The exception object persisted in db
      # @return [Net::HTTPResponse] The response object
      def process(response, ex)
        req = Eyeloupe::OutRequest.create(
          verb: @request.method,
          hostname: @request['host'],
          path: @request.path,
          status: response.code,
          format: response.content_type,
          duration: (Time.now - @started_at) * 1000,
          payload: @request.body,
          req_headers: (get_headers(@request) || {}).to_json,
          res_headers: (get_headers(response) || {}).to_json,
          response: response.body,
          )

        ex.update(out_request_id: req.id) if ex.present? && ex.out_request_id.blank?

        response
      end

      protected

      # @param [Net::HTTPRequest, Net::HTTPResponse] el The request or response object to get headers from
      def get_headers(el)
        headers = {}
        el.each_header do |key, value|
          headers[key] = value
        end
        headers
      end

    end
  end
end
