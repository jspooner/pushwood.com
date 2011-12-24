require 'spec_helper'
require "cancan/matchers"

describe User do
  describe "Authenication" do
    context "guest user" do
      subject { Ability.new(Factory(:user)) }
      it { should_not be_able_to(:create, Image) }
      it { should_not be_able_to(:edit, Image) }
      it { should_not be_able_to(:destroy, Image) }
      
      it { should_not be_able_to(:revert, Location) }
      it { should_not be_able_to(:destroy, Location) }
      
      it { should     be_able_to(:read, Factory(:location)) }
      it { should     be_able_to(:read, Rate) }
    end
    # context "user (photo)" do
    #   subject { Ability.new(Factory(:user_photo)) }
    #   it { should     be_able_to(:create, Image) }
    #   it { should_not be_able_to(:destroy, Image) }
    # end
    # context "user (admin)" do
    #   subject { Ability.new(Factory(:user_admin)) }
    #   it { should be_able_to(:manage, Image) }
    #   it { should be_able_to(:destroy, Factory(:image)) }
    #   it { should be_able_to(:edit, Factory(:location)) }
    # end
  end
end