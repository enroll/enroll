class ChangeBlogPostsContentToText < ActiveRecord::Migration
  def change
  	change_column :blog_posts, :content, :text, :limit => nil
  end
end
