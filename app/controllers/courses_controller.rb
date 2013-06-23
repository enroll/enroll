class CoursesController < ApplicationController

  def new
    @course = Course.new
  end

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end
end
