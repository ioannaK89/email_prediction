require 'spec_helper'

describe EmailPredictor do
  let(:predictor) { described_class.new(username, domain) }
  let(:username)  { 'John Ferguson' }
  let(:domain)    { 'alphasights.com' }

  describe '.new' do
    it 'assigns a user name' do
      expect(predictor.username).to eq(username)
    end

    it 'assigns a domain' do
      expect(predictor.domain).to eq(domain)
    end
  end

  describe '#predict' do
    context 'When username is missing' do
      let(:username) { nil }

      it 'raises an exception' do
        expect { predictor.predict }.to raise_error(RuntimeError, 'Missing username')
      end
    end

    context 'When domain is missing' do
      let(:domain) { nil }

      it 'raises an exception' do
        expect { predictor.predict }.to raise_error(RuntimeError, 'Missing domain')
      end
    end

    context 'When domain doesnt exists in the database' do
      before do
        allow(User).to receive(:all).and_return([])
      end

      let(:expected_predictions) do
        [
          "john.ferguson@alphasights.com",
          "john.f@alphasights.com",
          "j.ferguson@alphasights.com",
          "j.f@alphasights.com"
        ]
      end

      it "should return 4 possible predictions" do
        expect(predictor.predict).to eq(expected_predictions)
      end
    end

    context 'When domain exists in the database' do
      context 'When the format of email is: first_name_dot_last_name' do

        before do
          allow(User).to receive(:all).and_return([user])
        end

        let(:user) { User.new('Joanna Kostaki', 'joanna.kostaki@alphasights.com') }

        it 'should return first_name_dot_last_name prediction' do
          expect(predictor.predict).to eq('john.ferguson@alphasights.com')
        end
      end

      context 'When the format of email is: first_name_dot_last_initial' do

        before do
          allow(User).to receive(:all).and_return([user])
        end

        let(:user) { User.new('Joanna Kostaki', 'joanna.k@alphasights.com') }

        it 'should return first_name_dot_last_initial prediction' do
          expect(predictor.predict).to eq('john.f@alphasights.com')
        end
      end

      context 'When the format of email is: first_initial_dot_last_initial' do

        before do
          allow(User).to receive(:all).and_return([user])
        end

        let(:user) { User.new('Joanna Kostaki', 'j.k@alphasights.com') }

        it 'should return first_initial_dot_last_initial prediction' do
          expect(predictor.predict).to eq('j.f@alphasights.com')
        end
      end

      context 'When the format of email is: first_initial_dot_last_name' do

        before do
          allow(User).to receive(:all).and_return([user])
        end

        let(:user) { User.new('Joanna Kostaki', 'j.kostaki@alphasights.com') }

        it 'should return first_initial_dot_last_name prediction' do
          expect(predictor.predict).to eq('j.ferguson@alphasights.com')
        end
      end
    end
  end
end