class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name, :email, :password_digest

      t.timestamps
    end
  end
end
