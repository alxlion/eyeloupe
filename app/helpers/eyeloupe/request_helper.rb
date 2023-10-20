# frozen_string_literal: true

module Eyeloupe
  module RequestHelper
    # @param [Eyeloupe::InRequest, Eyeloupe::OutRequest] request The request object
    # @return [String] The formatted response
    def format_response(request)
      type = request.format.to_s != '*/*' ? request.format.to_s : request&.headers
      format(type, request.response)
    end

    # @param [Eyeloupe::InRequest, Eyeloupe::OutRequest] request The request object
    # @return [String] The formatted payload
    def format_payload(request)
      type = request.format.to_s != '*/*' ? request.format.to_s : request&.headers
      format(type, request.payload)
    end

    private

    def format(format, str)
      case format
      when /json/
        JSON.pretty_generate(JSON.parse(str || '{}'))
      when /xml/
        Nokogiri::XML(str || '<></>').to_xml(indent: 2)
      else
        str
      end
    end
  end
end
