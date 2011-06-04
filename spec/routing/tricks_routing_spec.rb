require "spec_helper"

describe TricksController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/tricks" }.should route_to(:controller => "tricks", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/tricks/new" }.should route_to(:controller => "tricks", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tricks/1" }.should route_to(:controller => "tricks", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tricks/1/edit" }.should route_to(:controller => "tricks", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/tricks" }.should route_to(:controller => "tricks", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/tricks/1" }.should route_to(:controller => "tricks", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tricks/1" }.should route_to(:controller => "tricks", :action => "destroy", :id => "1")
    end

  end
end
