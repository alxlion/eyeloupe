module Eyeloupe
  class InRequest < ApplicationRecord
    has_one :exception, class_name: "Eyeloupe::Exception"
  end
end
