class BlogPostsController < ApplicationController
  before_filter :setup_markdown
  before_filter { add_body_class 'welcome' }

  def index
    @posts = BlogPost.order('published_at desc')
  end

  def show
    @post = BlogPost.find_by_url(params[:id])
  end
end 