require 'spec_helper'

describe User do

  describe '.new' do
    let(:user) { described_class.new('John Ferguson', 'j.f@alphasights.com') }

    it "should initialize a user with username" do
      expect(user.username).to eq('John Ferguson')
    end

    it "should initialize a user with domain" do
      expect(user.domain).to eq('alphasights.com')
    end
  end

  describe '.all' do
    let(:excepted_user) { { users: ['Joanna' => 'joanna@alphasights.com'] } }
    let(:user) { double }

    before do
      allow(YAML).to receive(:load_file).with('config/db.yml').and_return(excepted_user)
      allow(described_class).to receive(:new).with('Joanna', 'joanna@alphasights.com').and_return(user)
    end

    it "should read and format all users from the database" do
      expect(User.all).to eq([user])
    end
  end

  describe '#first_name' do
    let(:user) { described_class.new('John Ferguson', 'j.f@alphasights.com') }

    it "should return the first name" do
      expect(user.first_name).to eq('john')
    end
  end

  describe '#last_name' do
    let(:user) { described_class.new('John Ferguson', 'j.f@alphasights.com') }

    it "should return the last name" do
      expect(user.last_name).to eq('ferguson')
    end
  end

  describe '#domain_exists?' do
    context 'When domain exists in the database' do

      before do
        allow(described_class).to receive(:all).and_return([user])
      end

      let(:user) { described_class.new('John Ferguson', 'j.f@alphasights.com') }

      it 'returns true' do
        expect(described_class.domain_exists?('alphasights.com')).to eq(true)
      end
    end
  end

  describe '.find_by_domain' do
    context 'When domain exists in the database' do

      before do
        allow(described_class).to receive(:all).and_return([user])
      end

      let(:user) { described_class.new('John Ferguson', 'j.f@alphasights.com') }

      it 'returns the user' do
        expect(described_class.find_by_domain('alphasights.com')).to eq(user)
      end
    end
  end

  describe '#domain' do
    let(:user) { described_class.new('John Ferguson', 'j.f@alphasights.com') }

    it 'returns the domain from the email' do
      expect(user.domain).to eq('alphasights.com')
    end
  end
end