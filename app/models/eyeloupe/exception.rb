module Eyeloupe
  class Exception < ApplicationRecord
    has_one :in_request
  end
end
