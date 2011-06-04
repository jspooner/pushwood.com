require 'spec_helper'

describe "tricks/show.html.erb" do
  before(:each) do
    @trick = assign(:trick, stub_model(Trick,
      :user_id => 1,
      :image_file_name => "Image File Name",
      :image_content_type => "Image Content Type",
      :image_file_size => 1,
      :lat => "Lat",
      :lng => "Lng"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Image File Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Image Content Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Lat/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Lng/)
  end
end
