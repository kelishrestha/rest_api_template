# frozen_string_literal: true
require 'rails_helper'

describe CreateUser do
  let(:params) do
    {
      first_name: 'Suzume',
      last_name: 'Yosano',
      dob: '1992-12-01',
      image: 'http://pm1.narvii.com/6282/0592a2f2698b13caa17546344c9e9553071aea7a_00.jpg',
      married: false,
      age: 20,
      email: 'suzume.yosano@hnr.com'
    }
  end

  describe '#call' do
    subject(:create_user) { described_class.new(params).call }

    it 'creates user' do
      expect { create_user }.to change { User.count }.by(1)
    end
  end
end
