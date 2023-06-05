module Eyeloupe
  class Exception < ApplicationRecord
    has_one :in_request, class_name: "Eyeloupe::InRequest"
  end
end
