class CreateEyeloupeOutRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :eyeloupe_out_requests do |t|
      t.string :verb
      t.string :hostname
      t.string :path
      t.string :format
      t.integer :status
      t.integer :duration
      t.text :payload
      t.text :req_headers
      t.text :res_headers
      t.text :response

      t.timestamps
    end
  end
end
