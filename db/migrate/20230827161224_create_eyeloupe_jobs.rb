class CreateEyeloupeJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :eyeloupe_jobs do |t|
      t.string :classname
      t.string :job_id
      t.string :queue_name
      t.string :adapter
      t.integer :status, default: 0
      t.datetime :scheduled_at
      t.datetime :executed_at
      t.datetime :completed_at
      t.integer :retry, default: 0
      t.string :args
      t.timestamps

      t.index :job_id, unique: true
    end
  end
end
