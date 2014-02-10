class AddUrlToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :url, :string
  end
end
