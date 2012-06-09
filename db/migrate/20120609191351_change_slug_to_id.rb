class ChangeSlugToId < ActiveRecord::Migration
  def up 
    change_column :quotes, :id, :string
    remove_column :quotes, :slug
  end

  def down
    change_column :quotes, :id, :integer
    add_column :quotes, :slug, :string
  end
end
