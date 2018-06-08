# frozen_string_literal: true

describe Stenographer::Output, type: :model do
  it 'has a valid blueprint' do
    expect(build(:output)).to be_valid
  end

  describe 'Associations' do
    subject { build(:output) }

    it { is_expected.to belong_to(:authentication).class_name('Stenographer::Authentication') }
  end

  describe 'Validations' do
    subject { create(:output) }

    it { is_expected.to validate_presence_of(:authentication_id) }
    it { is_expected.to validate_presence_of(:configuration) }
  end

  describe 'Methods' do
    let!(:output) { create(:output) }

    describe '#configuration_hash' do
      describe 'nil' do
        before :each do
          output.update(configuration: nil)
        end

        it 'empty hash' do
          expect(output.configuration_hash).to eq({})
        end
      end

      describe 'has data' do
        before :each do
          output.update(configuration: { country: 'Ibiza' }.to_json)
        end

        it 'hash with values' do
          expect(output.configuration_hash[:country]).to eq('Ibiza')
        end
      end
    end

    describe '#filters_hash' do
      describe 'nil' do
        before :each do
          output.update(filters: nil)
        end

        it 'empty hash' do
          expect(output.filters_hash).to eq({})
        end
      end

      describe 'has data' do
        before :each do
          output.update(filters: { country: 'Ibiza' }.to_json)
        end

        it 'hash with values' do
          expect(output.filters_hash[:country]).to eq('Ibiza')
        end
      end
    end

    describe '#provider' do
      it 'returns the authentication provider' do
        expect(output.provider).to eq(output.authentication.provider)
      end
    end
  end
end
