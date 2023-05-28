# frozen_string_literal: true
require 'net/http'
module Net
  class HTTP
    alias original_request request

    def request(req, body = nil, &block)
      if Eyeloupe.configuration.capture
        Eyeloupe::Processors::OutRequest.instance.init(req, body)
        res = original_request(req, body, &block)
        Eyeloupe::Processors::OutRequest.instance.process(res)
      else
        res = original_request(req, body, &block)
      end
      res
    end

  end
end