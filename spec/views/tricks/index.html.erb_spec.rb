require 'spec_helper'

describe "tricks/index.html.erb" do
  before(:each) do
    assign(:tricks, [
      stub_model(Trick,
        :user_id => 1,
        :image_file_name => "Image File Name",
        :image_content_type => "Image Content Type",
        :image_file_size => 1,
        :lat => "Lat",
        :lng => "Lng"
      ),
      stub_model(Trick,
        :user_id => 1,
        :image_file_name => "Image File Name",
        :image_content_type => "Image Content Type",
        :image_file_size => 1,
        :lat => "Lat",
        :lng => "Lng"
      )
    ])
  end

  it "renders a list of tricks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Image File Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Image Content Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Lat".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Lng".to_s, :count => 2
  end
end
