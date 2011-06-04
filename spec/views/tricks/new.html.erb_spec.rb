require 'spec_helper'

describe "tricks/new.html.erb" do
  before(:each) do
    assign(:trick, stub_model(Trick,
      :user_id => 1,
      :image_file_name => "MyString",
      :image_content_type => "MyString",
      :image_file_size => 1,
      :lat => "MyString",
      :lng => "MyString"
    ).as_new_record)
  end

  it "renders new trick form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tricks_path, :method => "post" do
      assert_select "input#trick_user_id", :name => "trick[user_id]"
      assert_select "input#trick_image_file_name", :name => "trick[image_file_name]"
      assert_select "input#trick_image_content_type", :name => "trick[image_content_type]"
      assert_select "input#trick_image_file_size", :name => "trick[image_file_size]"
      assert_select "input#trick_lat", :name => "trick[lat]"
      assert_select "input#trick_lng", :name => "trick[lng]"
    end
  end
end
