require "spec_helper"

describe WorkshopsController do
  it "displays a directory of workshops" do
    get :index
    must_respond_with :success
    must_render_template :index
    # assigns(:workshops).wont_be_nil
  end
end
