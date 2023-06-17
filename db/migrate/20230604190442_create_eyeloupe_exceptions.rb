class CreateEyeloupeExceptions < ActiveRecord::Migration[7.0]
  def change
    create_table :eyeloupe_exceptions do |t|
      t.string :hostname
      t.string :kind
      t.string :location
      t.string :file
      t.integer :line
      t.text :stacktrace
      t.string :message
      t.integer :count, default: 1
      t.text :full_message
      t.references :in_request, null: true, foreign_key: { to_table: :eyeloupe_in_requests }
      t.references :out_request, null: true, foreign_key: { to_table: :eyeloupe_out_requests }

      t.timestamps
    end

    add_index :eyeloupe_exceptions, [:kind, :file, :line]
  end
end
