require 'spec_helper'

describe "cd_pages/show.html.erb" do
  before(:each) do
    @cd_page = assign(:cd_page, stub_model(CdPage,
      :url => "Url",
      :guid => "Guid"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Guid/)
  end
end
