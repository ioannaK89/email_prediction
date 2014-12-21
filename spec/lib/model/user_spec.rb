require 'spec_helper'

describe User do
  describe '.all' do
    let(:excepted_user) { { users: ['Joanna' => 'alphasights.com'] } }

    before do
      allow(YAML).to receive(:load_file).with('config/db.yml').and_return(excepted_user)
    end

    it "should read and format all users from the database" do
      expect(User.all).to eq([{:name=>"Joanna", :domain=>"alphasights.com"}])
    end
  end
end