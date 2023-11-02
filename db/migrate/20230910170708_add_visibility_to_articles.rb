class AddVisibilityToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :visibility, :string
  end
end
