module Eyeloupe
  class Job < ApplicationRecord
    enum status: [:enqueued, :running, :completed, :failed, :discarded]
  end
end
