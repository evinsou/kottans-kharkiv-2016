class CreateMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :messages do |t|
      t.string :body, null: false
      t.string :link, null: false
      t.string :token, null: false
      t.string :param_type, null: false
      t.integer :param_amount, null: false
      t.timestamps null: false
    end
  end
end
