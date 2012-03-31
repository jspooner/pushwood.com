require 'spec_helper'
require "cancan/matchers"

describe User do
  describe "Authenication" do
    
    context "guest user" do
      before(:each) do
        # Photo role is added after create on user model
        @user = Factory(:user)
        @user.roles = []
        @user.save
      end
      subject { Ability.new(@user) }
      it { should_not be_able_to(:create, Image) }
      it { should_not be_able_to(:edit, Image) }
      it { should_not be_able_to(:destroy, Image) }
      
      it { should_not be_able_to(:revert, Location) }
      it { should_not be_able_to(:destroy, Location) }
      
      it { should     be_able_to(:read, Factory(:location)) }
      it { should     be_able_to(:read, Rate) }
    end
    
    context "user (photo)" do
      let(:user) { Factory(:user) }
      subject { Ability.new(user) }
      it { should     be_able_to(:create, Image) }
      it { should_not be_able_to(:destroy, Factory(:image)) }
      it { should     be_able_to(:destroy, Factory(:image, { user: user})) }
    end
    
    context "user (admin)" do
      subject { Ability.new(Factory(:user_admin)) }
      it { should be_able_to(:manage, Image) }
      it { should be_able_to(:destroy, Factory(:image)) }
      it { should be_able_to(:edit, Factory(:location)) }
    end
    
  end
  describe "Facebook" do
    it "should have a token" do
      @user = Factory(:user)
      @user.authentications.create!(:provider => 'facebook', :uid => '444', :token => "AAA666")
      @user.authentications.first.token.should eql("AAA666")
      @user.facebook_access_token.should eql("AAA666")
    end
    it "should not have a token" do
      @user = Factory(:user)
      @user.authentications.create!(:provider => 'google', :uid => '444')
      @user.authentications.first.token.should be_nil
      @user.facebook_access_token.should be_nil
    end
  end
end