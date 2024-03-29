class CreateUserModel < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :user, :string
      t.column :password, :string
      t.column :count, :integer
    end
  end

  def self.down
    drop_table :users
  end
end