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
        change = build(:change, environments: ' WOW ')
        expect(change).to receive(:sanitize_environment)

        change.save
      end
    end

    describe 'after_commit on: :create' do
      it 'calls send_to_outputs' do
        change = build(:change, environments: ' WOW ')
        expect(change).to receive(:send_to_outputs)

        change.save
      end
    end

    describe 'after_update' do
      it 'calls send_to_outputs if the environment changes' do
        change = create(:change)
        expect(change).to receive(:send_to_outputs)

        change.update(environments: 'tea')
      end

      it 'does not call send_to_outputs if the other fields change' do
        change = create(:change)
        expect(change).not_to receive(:send_to_outputs)

        change.update(change_type: 'new')
      end
    end
  end

  describe 'Methods' do
    describe '#sanitize_environment' do
      it 'downcases and removes spaces' do
        change = build(:change, environments: ' WOW ')

        expect(change.sanitize_environment).to eq('wow')
      end

      it 'does not break multiple environments' do
        change = build(:change, environments: 'thing1, thing2')

        expect(change.sanitize_environment).to eq('thing1, thing2')
      end

      it 'uniques the items' do
        change = build(:change, environments: 'thing1, thing2, thing1')

        expect(change.sanitize_environment).to eq('thing1, thing2')
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
        describe 'normal field' do
          before :each do
            change.update(change_type: 'new')
            output.update(filters: { change_type: 'new' }.to_json)
          end

          it 'returns true' do
            expect(change.matches_filters(output)).to be_truthy
          end
        end

        describe 'environments' do
          describe 'matches last' do
            before :each do
              change.update(environments: 'florida, california')
              output.update(filters: { environments: 'california' }.to_json)
            end

            it 'returns true' do
              expect(change.matches_filters(output)).to be_truthy
            end
          end

          describe 'does not match if not last' do
            before :each do
              change.update(environments: 'california, florida')
              output.update(filters: { environments: 'california' }.to_json)
            end

            it 'returns true' do
              expect(change.matches_filters(output)).to be_falsey
            end
          end
        end
      end

      describe 'has empty match' do
        before :each do
          change.update(environments: 'staging')
          output.update(filters: { environments: '' }.to_json)
        end

        it 'returns true' do
          expect(change.matches_filters(output)).to be_truthy
        end
      end

      describe 'no match' do
        before :each do
          change.update(environments: 'community')
          output.update(filters: { environments: 'the office' }.to_json)
        end

        it 'returns false' do
          expect(change.matches_filters(output)).to be_falsey
        end
      end
    end

    describe '#environments_to_tags' do
      let!(:change) { create(:change) }

      describe 'single environment' do
        it 'returns a single item' do
          tag_array = change.environments_to_tags

          expect(tag_array.length).to eq(1)
        end

        it 'returns a tag hash' do
          change.update(environments: 'cheese')
          tag_array = change.environments_to_tags

          expect(tag_array.first[:name]).to eq('Cheese')
          expect(tag_array.first[:color]).to eq('is-light')
        end

        it 'production gets special color' do
          change.update(environments: 'production')
          tag_array = change.environments_to_tags

          expect(tag_array.first[:name]).to eq('Production')
          expect(tag_array.first[:color]).to eq('is-primary')
        end
      end

      describe 'multiple environments' do
        it 'returns a multiple items' do
          change.update(environments: 'staging, production')
          tag_array = change.environments_to_tags

          expect(tag_array.length).to eq(2)
        end
      end
    end

    describe '.create_or_update_by_source_id' do
      describe 'has source id' do
        describe 'source id found' do
          let!(:existing_change) { create(:change, source_id: '#aol', environments: 'england') }

          it 'does not create a new change' do
            expect {
              Stenographer::Change.create_or_update_by_source_id({
                                                                     subject: 'test',
                                                                     message: 'test1',
                                                                     source_id: '#aol',
                                                                     visible: true,
                                                                     environments: 'france',
                                                                     tracker_ids: '1234',
                                                                     source: {}.to_json
                                                                 })
            }.not_to change(Stenographer::Change, :count)
          end

          it 'adds to the changes environment' do
            Stenographer::Change.create_or_update_by_source_id({
                                                                   subject: 'test',
                                                                   message: 'test1',
                                                                   source_id: '#aol',
                                                                   visible: true,
                                                                   environments: 'france',
                                                                   tracker_ids: '1234',
                                                                   source: {}.to_json
                                                               })

            expect(existing_change.reload.environments).to eq('england, france')
          end
        end

        describe 'source id not found' do
          it 'creates a new change' do
            expect {
              Stenographer::Change.create_or_update_by_source_id({
                                                                     subject: 'test',
                                                                     message: 'test1',
                                                                     source_id: '#14983989',
                                                                     visible: true,
                                                                     environments: 'test',
                                                                     tracker_ids: '1234',
                                                                     source: {}.to_json
                                                                 })
            }.to change(Stenographer::Change, :count).by(1)
          end
        end
      end

      describe 'no source id' do
        it 'creates a new change' do
          expect {
            Stenographer::Change.create_or_update_by_source_id({
                                                                 subject: 'test',
                                                                 message: 'test1',
                                                                 visible: true,
                                                                 environments: 'test',
                                                                 tracker_ids: '1234',
                                                                 source: {}.to_json
                                                               })
          }.to change(Stenographer::Change, :count).by(1)
        end
      end
    end
  end
end
