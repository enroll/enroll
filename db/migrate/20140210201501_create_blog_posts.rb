class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :content
      t.integer :author_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
