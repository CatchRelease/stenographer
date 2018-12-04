# frozen_string_literal: true

describe Stenographer::Link, type: :model do
  it 'has a valid blueprint' do
    expect(build(:link)).to be_valid
  end

  describe 'Validations' do
    subject { create(:link) }

    it { is_expected.to validate_presence_of(:url) }
  end
end
