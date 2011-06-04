require "spec_helper"

describe CdPagesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/cd_pages" }.should route_to(:controller => "cd_pages", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/cd_pages/new" }.should route_to(:controller => "cd_pages", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/cd_pages/1" }.should route_to(:controller => "cd_pages", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/cd_pages/1/edit" }.should route_to(:controller => "cd_pages", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/cd_pages" }.should route_to(:controller => "cd_pages", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/cd_pages/1" }.should route_to(:controller => "cd_pages", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/cd_pages/1" }.should route_to(:controller => "cd_pages", :action => "destroy", :id => "1")
    end

  end
end
