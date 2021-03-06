class PostsController < ApplicationController
  skip_before_filter :authenticate, :only => [:index, :show]

  def index
    @posts = Post.all
  end

  def archive
    @posts = Post.all
    @posts_by_month = @posts.group_by { |t| t.created_at.beginning_of_month }  
    @month = params[:month]
  end

  def new 
    @post = Post.new
    @tags = Tag.all
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = 'Post created succesfully'
      redirect_to post_path(@post.id) 
    else
      # Bad change new to eager load?
      #@post.errors.each do |local, error|
       # flash_message(:error, "#{local} - #{error}")
      #end
      @tags = Tag.all
      render 'new'
    end
  end

  def update
    @post = Post.find_by_id(params[:id])
    @post.update(post_params)
    if @post.save
      redirect_to post_path(@post.id)
    else
      render edit_post_path(@post.id)
    end
  end
  
  def show
    @post = Post.find_by_id(params[:id])
    if @post.nil? || @post.visible == false
      flash[:error] = 'Post not found'
      redirect_to root_path
    end
  end
  
  def edit
    @post = Post.find_by_id(params[:id])
    @tags = Tag.all
  end

  private

  def post_params
    params.require(:post).permit(:subject, :visible, :starred, :tag_id, :main_body, :caption, :main_image, :main_image_cache)
  end

end
