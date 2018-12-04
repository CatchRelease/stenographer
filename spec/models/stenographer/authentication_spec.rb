# frozen_string_literal: true

describe Stenographer::Authentication, type: :model do
  it 'has a valid blueprint' do
    expect(build(:authentication)).to be_valid
  end

  describe 'Associations' do
    subject { build(:authentication) }

    it { is_expected.to have_many(:outputs).class_name('Stenographer::Output').dependent(:destroy) }
  end

  describe 'Validations' do
    subject { create(:authentication) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }
  end

  describe 'Methods' do
    describe '.providers' do
      it 'returns all the providers available' do
        create(:authentication, provider: 'alpha')
        create(:authentication, provider: 'alpha')
        create(:authentication, provider: 'beta')

        expect(Stenographer::Authentication.providers).to eq(%w[alpha beta])
      end
    end

    describe '#credentials_hash' do
      let!(:authentication) { create(:authentication) }

      describe 'nil' do
        before do
          authentication.update(credentials: nil)
        end

        it 'empty hash' do
          expect(authentication.credentials_hash).to eq({})
        end
      end

      describe 'has data' do
        before do
          authentication.update(credentials: { country: 'Ibiza' }.to_json)
        end

        it 'hash with values' do
          expect(authentication.credentials_hash[:country]).to eq('Ibiza')
        end
      end
    end
  end
end
