class Admin::PostsController < ApplicationController
  before_filter :authenticate_user!
  http_basic_authenticate_with :name => "enroll", :password => "coffee"

  def index
    @posts = BlogPost.all
  end

  def new
    @post = BlogPost.new
  end

  def create
    @post = BlogPost.new(post_params)
    @post.author = current_user

    if @post.save
      @post.publish!
      redirect_to admin_posts_path
    else
      render 'new'
    end
  end

  def edit
    @post = BlogPost.find(params[:id])
  end

  def update
    @post = BlogPost.find(params[:id])
    @post.author ||= current_user

    if @post.update_attributes(post_params)
      redirect_to admin_posts_path
    else
      render 'edit'
    end
  end

  def destroy
    BlogPost.find(params[:id]).delete
    redirect_to admin_posts_path
  end

  protected

  def post_params
    params.require(:blog_post).permit(:title, :content, :intro)
  end
end