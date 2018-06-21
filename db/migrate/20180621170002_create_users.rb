class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :image
      t.datetime :dob
      t.integer :age
      t.boolean :married

      t.timestamps
    end
    add_index :users, :uid
  end
end
