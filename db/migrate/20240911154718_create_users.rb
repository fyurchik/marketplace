class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :confirmation_token
      t.string :confirmed_at
      t.string :confirmation_sent_at

      t.timestamps
    end
  end
end
