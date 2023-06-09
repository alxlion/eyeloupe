module Eyeloupe
  class OutRequest < ApplicationRecord
    has_one :exception, class_name: "Eyeloupe::Exception"
  end
end
