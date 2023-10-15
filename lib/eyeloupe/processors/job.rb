# frozen_string_literal: true
module Eyeloupe
  module Processors
    class Job
      include Singleton

      # @return [Array]
      attr_accessor :subs

      def initialize
        @subs = []
      end

      # @param [ActiveSupport::Notifications::Event] event The event object
      def process(event)
        job = event.payload[:job]

        Eyeloupe::Job.create(
          classname: job.class.name,
          job_id: job.job_id,
          queue_name: queue_name(event),
          adapter: adapter_name(event),
          scheduled_at: scheduled_at(event),
          status: :enqueued,
          args: (args_info(job) || {}).to_json
        )
      end

      # @param [ActiveSupport::Notifications::Event] event The event object
      def run(event)
        job = event.payload[:job]

        Eyeloupe::Job.where(job_id: job.job_id).update(status: :running, executed_at: Time.now.utc)
      end

      # @param [ActiveSupport::Notifications::Event] event The event object
      def complete(event)
        job = event.payload[:job]

        existing = Eyeloupe::Job.where(job_id: job.job_id).first

        puts existing.inspect

        puts job.inspect

        if existing.failed?
          Eyeloupe::Job.where(job_id: job.job_id).update(completed_at: Time.now.utc, retry: existing.retry + 1)
        else
          Eyeloupe::Job.where(job_id: job.job_id).update(status: :completed, completed_at: Time.now.utc, retry: job.executions - 1)
        end
      end

      # @param [ActiveSupport::Notifications::Event] event The event object
      def failed(event)
        job = event.payload[:job]

        Eyeloupe::Job.where(job_id: job.job_id).update(status: :failed)
      end

      # @param [ActiveSupport::Notifications::Event] event The event object
      def discard(event)
        job = event.payload[:job]

        Eyeloupe::Job.where(job_id: job.job_id).update(status: :discarded)
      end

      # @param [ActiveJob::Base] job The job object
      # @return [Array, nil]
      def args_info(job)
        if job.class.log_arguments? && job.arguments.any?
          job.arguments
        end
      end

      private

      # @param [ActiveSupport::Notifications::Event] event The event object
      # @return [String] The name of the queue
      def queue_name(event)
        event.payload[:job].queue_name
      end

      # @param [ActiveSupport::Notifications::Event] event The event object
      # @return [String] The name of the adapter
      def adapter_name(event)
        event.payload[:adapter].class.name.demodulize.remove("Adapter")
      end

      # @param [ActiveSupport::Notifications::Event] event The event object
      # @return [Time, nil] The time the job was scheduled at
      def scheduled_at(event)
        return unless event.payload[:job].scheduled_at
        Time.at(event.payload[:job].scheduled_at).utc
      end

      # @param [String] event The event to subscribe to
      # @param [Proc] block The block to execute when the event is triggered
      # @yield [ActiveSupport::Notifications::Event] The event object
      def subscribe(event, &block)
        @subs << ActiveSupport::Notifications.subscribe(event) do |*args|
          block.call(ActiveSupport::Notifications::Event.new(*args))
        end
      end

      def unsubscribe
        @subs.each do |sub|
          ActiveSupport::Notifications.unsubscribe(sub)
        end
        @subs = []
      end
    end
  end
end