# frozen_string_literal: true
RSpec.shared_examples 'Form Validation Success' do
  let(:validation_subject) { subject }

  it 'returns true without error message' do
    expect(validation_subject).to eq([true, nil])
  end
end

RSpec.shared_examples 'Form Validation Failure' do
  let(:validation_subject) { subject }
  let(:error_block) { [] }
  let(:error_message) do
    {
      message: 'Validation Failed',
      errors: error_block
    }
  end

  it 'returns false along with error message' do
    expect(validation_subject).to eq([false, error_message])
  end
end
