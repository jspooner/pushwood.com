require 'spec_helper'

describe "cd_pages/index.html.erb" do
  before(:each) do
    assign(:cd_pages, [
      stub_model(CdPage,
        :url => "Url",
        :guid => "Guid"
      ),
      stub_model(CdPage,
        :url => "Url",
        :guid => "Guid"
      )
    ])
  end

  it "renders a list of cd_pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Guid".to_s, :count => 2
  end
end
