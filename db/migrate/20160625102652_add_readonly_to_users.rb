class AddReadonlyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :read_only, :binary, default: false, null: false
  end
end
