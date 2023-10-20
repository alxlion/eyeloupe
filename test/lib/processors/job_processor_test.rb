# frozen_string_literal: true

require "test_helper"
include ActiveJob::TestHelper

class JobProcessorTest < ActiveSupport::TestCase
  def setup
    @job_processor = Eyeloupe::Processors::Job.instance

    activejob = ActiveJob::Base.new
    activejob.job_id = SecureRandom.uuid
    @event = ActiveSupport::Notifications::Event.new("test.event", Time.now, Time.now, SecureRandom.uuid, {job: activejob})
  end

  test "should initialize job processor" do
    assert_not_nil @job_processor
    assert_equal [], @job_processor.subs
  end

  test "should process" do
    job = @job_processor.process(@event)
    assert_not_nil job
    assert job.persisted?
  end

  test "should run" do
    job = @job_processor.process(@event)
    @job_processor.run(@event)
    job.reload
    assert_equal "running", job.status
  end

  test "should complete without fail" do
    job = @job_processor.process(@event)
    @job_processor.run(@event)
    @job_processor.complete(@event)
    job.reload
    assert_equal "completed", job.status
    assert_equal 0, job.retry
  end

  test "should complete with fail" do
    job = @job_processor.process(@event)
    @job_processor.run(@event)
    job.update(status: :failed)
    @job_processor.complete(@event)
    job.reload
    assert_equal "failed", job.status
    assert_equal 1, job.retry
  end

  test "should be failed" do
    job = @job_processor.process(@event)
    @job_processor.failed(@event)
    job.reload
    assert_equal "failed", job.status
  end

  test "should be discarded" do
    job = @job_processor.process(@event)
    @job_processor.discard(@event)
    job.reload
    assert_equal "discarded", job.status
  end

end
