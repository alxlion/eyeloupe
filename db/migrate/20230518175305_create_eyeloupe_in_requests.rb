class CreateEyeloupeInRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :eyeloupe_in_requests do |t|
      t.string :verb
      t.string :hostname
      t.string :controller
      t.string :path
      t.string :format
      t.integer :status
      t.integer :duration
      t.integer :db_duration
      t.integer :view_duration
      t.string :ip
      t.text :payload
      t.text :headers
      t.text :session
      t.text :response

      t.timestamps
    end
  end
end
