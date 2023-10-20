module Eyeloupe
  class Job < ApplicationRecord
    validates :job_id, uniqueness: true

    enum status: [:enqueued, :running, :completed, :failed, :discarded]
  end
end
