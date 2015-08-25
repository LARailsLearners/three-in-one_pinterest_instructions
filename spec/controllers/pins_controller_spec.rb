require 'rails_helper'

RSpec.describe PinsController, type: :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end 

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end 

    it "loads all of the pins into @pins" do
      pin1, pin2 = Pin.create!, Pin.create!
      get :index

      expect(assigns(:pins)).to match_array([pin1, post2])
    end 
  end 
end

