module Eyeloupe
  class Exception < ApplicationRecord
    has_one :in_request, class_name: "Eyeloupe::InRequest"
    has_one :out_request, class_name: "Eyeloupe::OutRequest"
  end
end
