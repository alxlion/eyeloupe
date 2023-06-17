module Eyeloupe
  module Concerns
    module Rescuable
      extend ActiveSupport::Concern

      included do
        rescue_from(StandardError) do |exception|
          Eyeloupe::Processors::Exception.instance.process(nil, exception)
        end
      end

    end
  end
end