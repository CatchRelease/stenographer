# frozen_string_literal: true

describe Stenographer::Change, type: :model do
  it 'has a valid blueprint' do
    expect(build(:change)).to be_valid
  end

  describe 'Validations' do
    subject { create(:change) }

    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_inclusion_of(:change_type).in_array(Stenographer::Change::VALID_CHANGE_TYPES) }
  end
end
