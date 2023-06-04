module Eyeloupe
  class InRequest < ApplicationRecord
    has_many :exceptions
  end
end
