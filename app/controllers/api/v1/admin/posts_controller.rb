class Api::V1::Admin::PostsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_post, only: [:update_status]

  def index
    @posts = Post.all.where(status:"pending")
    render json: @posts
  end

  def update_status
    if @post.update(status_params)
      render json: @post
    else
      render json: {errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def status_params
    params.require(:post).permit(:status)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
