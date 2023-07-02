module Eyeloupe
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    if Eyeloupe.configuration.database
      connects_to database: { writing: Eyeloupe.configuration.database.to_sym, reading: Eyeloupe.configuration.database.to_sym }
    end
  end
end
