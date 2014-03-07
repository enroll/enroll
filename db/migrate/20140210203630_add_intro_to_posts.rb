class AddIntroToPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :intro, :string
  end
end
