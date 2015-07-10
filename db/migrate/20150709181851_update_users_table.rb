class UpdateUsersTable < ActiveRecord::Migration
  def change
    change_column :polls, :author, :integer
    rename_column :polls, :author, :author_id
  end
end
