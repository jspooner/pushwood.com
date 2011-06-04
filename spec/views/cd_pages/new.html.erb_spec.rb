require 'spec_helper'

describe "cd_pages/new.html.erb" do
  before(:each) do
    assign(:cd_page, stub_model(CdPage,
      :url => "MyString",
      :guid => "MyString"
    ).as_new_record)
  end

  it "renders new cd_page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cd_pages_path, :method => "post" do
      assert_select "input#cd_page_url", :name => "cd_page[url]"
      assert_select "input#cd_page_guid", :name => "cd_page[guid]"
    end
  end
end
