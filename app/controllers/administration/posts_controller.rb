class Administration::PostsController < Administration::MainController

  before_filter :find_post, :only => [:update, :destroy]

  def index
    @posts = Post.includes(:admin).paginate(:per_page => 20, :page => params[:page])
  end

  def edit
    @post = Post.includes(:tags).find(params[:id])
  end

  def update
    @post.update_attributes(params[:post])
    redirect_to administration_post_path
  end

  def show
    @post = Post.includes([:comments, :tags]).find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_admin.posts.build(params[:post])
    if @post.save
      flash[:notice] = "Post successfully saved"
      redirect_to administration_post_path(@post)
    else
      flash[:error] = "All fields should not be null"
      render :action => :new
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Destroyed successfully"    
    redirect_to administration_posts_path
  end

  def preview
    @tags = []
    @post= Post.find_by_id(params[:id]) || Post.new
    render :layout => 'application'
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

end
