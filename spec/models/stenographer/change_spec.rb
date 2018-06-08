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

  describe 'Callbacks' do
    describe 'before_save' do
      it 'calls sanitize_environment' do
        change = build(:change, environment: ' WOW ')
        expect(change).to receive(:sanitize_environment)

        change.save
      end
    end

    describe 'after_commit on: :create' do
      it 'calls send_to_outputs' do
        change = build(:change, environment: ' WOW ')
        expect(change).to receive(:send_to_outputs)

        change.save
      end
    end
  end

  describe 'Methods' do
    describe '#sanitize_environment' do
      it 'downcases and removes spaces' do
        change = build(:change, environment: ' WOW ')

        expect(change.sanitize_environment).to eq('wow')
      end
    end

    describe '.environments' do
      it 'returns all the environments available' do
        create(:change, environment: 'alpha')
        create(:change, environment: 'Alpha')
        create(:change, environment: 'beta')

        expect(Stenographer::Change.environments).to eq(%w[all alpha beta])
      end
    end

    describe '#to_markdown' do
      subject { create(:change, message: '# hello') }

      it 'translates its message to markdown' do
        expect(subject.to_markdown.strip).to eq('<h1>hello</h1>')
      end
    end

    describe '#matches_filters' do
      let!(:change) { create(:change) }
      let!(:output) { create(:output) }

      describe 'no output' do
        it 'returns false' do
          expect(change.matches_filters).to be_falsey
        end
      end

      describe 'no filters' do
        it 'returns true' do
          expect(change.matches_filters(output)).to be_truthy
        end
      end

      describe 'has match' do
        before :each do
          change.update(environment: 'community')
          output.update(filters: { environment: 'community' }.to_json)
        end

        it 'returns true' do
          expect(change.matches_filters(output)).to be_truthy
        end
      end

      describe 'no match' do
        before :each do
          change.update(environment: 'community')
          output.update(filters: { environment: 'the office' }.to_json)
        end

        it 'returns false' do
          expect(change.matches_filters(output)).to be_falsey
        end
      end
    end
  end
end
