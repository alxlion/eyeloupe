class CreateEyeloupeExceptions < ActiveRecord::Migration[7.0]
  def change
    create_table :eyeloupe_exceptions do |t|
      t.string :hostname
      t.string :kind
      t.string :location
      t.text :stacktrace
      t.string :message
      t.integer :count, default: 1
      t.text :full_message
      t.references :eyeloupe_in_request, null: true, foreign_key: true

      t.timestamps
    end

    add_index :eyeloupe_exceptions, [:kind, :message]
  end
end
