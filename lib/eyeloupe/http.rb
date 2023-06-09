# frozen_string_literal: true
require 'net/http'
require 'eyeloupe/processors/exception'
require 'eyeloupe/processors/out_request'

module Net
  class HTTP
    alias original_request request

    def request(req, body = nil, &block)
      res, ex = nil
      exception_processor = Eyeloupe::Processors::Exception.instance
      out_request_processor = Eyeloupe::Processors::OutRequest.instance

      if Eyeloupe.configuration.capture
        begin
          out_request_processor.init(req, body)
          res = original_request(req, body, &block)
        rescue => e
          ex = exception_processor.process(nil, e)
        ensure
          out_request_processor.process(res, ex)
        end
      else
        res = original_request(req, body, &block)
      end
      res
    end

  end
end