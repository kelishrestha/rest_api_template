# frozen_string_literal: true
require 'rails_helper'

describe UpdateUser do
  describe '#call' do
    subject(:update_user) { described_class.new(user, params).call }

    let(:user_id) { Faker::Code.asin }
    let(:user) { FactoryGirl.create(:user, user_attributes) }
    let(:user_attributes) do
      {
        uid: user_id,
        first_name: 'Suzume',
        last_name: 'Yosano',
        dob: '1992-12-01',
        image: 'http://pm1.narvii.com/6282/0592a2f2698b13caa17546344c9e9553071aea7a_00.jpg',
        married: false,
        age: 20,
        email: 'suzume.yosano@hnr.com'
      }
    end

    let(:params) do
      {
        age: 25,
        email: 'suzume.yosano@gmail.com'
      }
    end

    it 'updates age of user' do
      expect{ update_user }.to change{ user.age }.from(20).to(25)
    end

    it 'updates email of user' do
      expect{ update_user }.to change{ user.email }.from('suzume.yosano@hnr.com').to('suzume.yosano@gmail.com')
    end
  end
end
