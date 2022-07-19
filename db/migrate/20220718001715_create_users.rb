class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number

      t.timestamps
    end

    add_index :users, [:phone_number, :last_name, :first_name], unique: true
  end
end
