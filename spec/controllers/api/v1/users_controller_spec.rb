# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :api do
  before do
    api_key = FactoryGirl.create(:api_key)
    header 'x-api-token', api_key.token
    header 'Content-type', 'application/json'
  end

  shared_context 'when required user parameters are missing' do
    context 'when first name is missing' do
      let(:request_body) { base_params.except(:first_name) }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'first_name', message: 'is missing' }
          ]
        end
      end
    end

    context 'when last name is missing' do
      let(:request_body) { base_params.except(:last_name) }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'last_name', message: 'is missing' }
          ]
        end
      end
    end

    context 'when age is missing' do
      let(:request_body) { base_params.except(:age) }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'age', message: 'is missing' }
          ]
        end
      end
    end

    context 'when image url is missing' do
      let(:request_body) { base_params.except(:image) }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'image', message: 'is missing' }
          ]
        end
      end
    end

    context 'when email is missing' do
      let(:request_body) { base_params.except(:email) }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'email', message: 'is missing' }
          ]
        end
      end
    end
  end

  shared_context 'when provided user parameters are invalid' do
    context 'when user name is blank' do
      let(:request_body) { base_params.merge(first_name: '') }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'first_name', message: 'must be a non-blank string' }
          ]
        end
      end
    end

    context 'when dob is invalid date' do
      let(:request_body) { base_params.merge(dob: '67890') }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'dob', message: 'must be a valid iso8601 date' }
          ]
        end
      end
    end

    context 'when age is other than integer' do
      let(:request_body) { base_params.merge(age: '20') }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'age', message: 'must be a non-zero number' }
          ]
        end
      end
    end

    context 'when married is other than boolean' do
      let(:request_body) { base_params.merge(married: 'unmarried') }

      include_examples 'Validation Failure' do
        let(:error_block) do
          [
            { field: 'married', message: 'must be a boolean' }
          ]
        end
      end
    end
  end

  describe '#create' do
    subject(:create_user) { post 'api/v1/users', request_body.to_json }

    let(:base_params) do
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

    let(:request_body) { base_params }

    include_context 'when required user parameters are missing'
    include_context 'when provided user parameters are invalid'

    context 'when provided user parameters are valid' do
      let(:user_response) do
        {
          id: User.last.uid,
          name: 'Suzume Yosano',
          dob: '1992-12-01T00:00:00Z',
          image: 'http://pm1.narvii.com/6282/0592a2f2698b13caa17546344c9e9553071aea7a_00.jpg',
          married: false,
          age: 20,
          email: 'suzume.yosano@hnr.com'
        }
      end

      it 'creates a user' do
        expect { create_user }.to change { User.count }.by(1)
      end

      include_examples 'Successfully Created', 'user' do
        let(:response_body) { user_response.to_json }
      end
    end
  end

  describe '#show' do
    subject(:get_user) { get "api/v1/users/#{user_id}" }

    let(:user_id) { Faker::Code.asin }

    context 'when user does not exist' do
      include_examples 'Resource not found', 'user' do
        let(:error_message) { 'user not found' }
      end
    end

    context 'when user exists' do
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

      let(:user) do
        FactoryGirl.create(:user, user_attributes)
      end

      before { user }

      include_examples 'Serving a Resource', 'user' do
        let(:response_body) do
          {
            id: user_id,
            name: 'Suzume Yosano',
            dob: '1992-12-01T00:00:00Z',
            image: 'http://pm1.narvii.com/6282/0592a2f2698b13caa17546344c9e9553071aea7a_00.jpg',
            married: false,
            age: 20,
            email: 'suzume.yosano@hnr.com'
          }.with_indifferent_access
        end
      end
    end
  end

  describe '#index' do
    subject(:list_users) { get "api/v1/users" }

    context 'when there are no user' do
      include_examples 'Validate Response', 200, 'returns empty list' do
        let(:response_body) { [] }
      end
    end

    context 'when users are present' do
      let(:user_1_uid) { Faker::Code.asin }
      let(:user_2_uid) { Faker::Code.asin }

      let(:user_1_attributes) do
        {
          uid: user_1_uid,
          first_name: 'Yosano',
          last_name: 'Suzume',
          dob: '1992-12-01',
          image: 'http://pm1.narvii.com/6282/0592a2f2698b13caa17546344c9e9553071aea7a_00.jpg',
          married: false,
          age: 20,
          email: 'suzume.yosano@hnr.com'
        }
      end
      let(:user_2_attributes) do
        {
          uid: user_2_uid,
          first_name: 'Daiki',
          last_name: 'Mamura',
          dob: '1992-12-01',
          image: 'https://i.pinimg.com/736x/3f/9d/f4/3f9df48174e0f6d7ba84d50cea92105c--hot-anime-anime-guys.jpg',
          married: false,
          age: 20,
          email: 'mamura.daiki@hnr.com'
        }
      end

      let(:user_1) { FactoryGirl.create(:user, user_1_attributes) }
      let(:user_2) { FactoryGirl.create(:user, user_2_attributes) }

      before do
        user_1
        user_2
      end

      include_examples 'Validate Response', 200, 'returns empty list' do
        let(:response_body) do
          [
            {
              id: user_1_uid,
              name: 'Yosano Suzume',
              dob: '1992-12-01T00:00:00Z',
              image: 'http://pm1.narvii.com/6282/0592a2f2698b13caa17546344c9e9553071aea7a_00.jpg',
              married: false,
              age: 20,
              email: 'suzume.yosano@hnr.com'
            },
            {
              id: user_2_uid,
              name: 'Daiki Mamura',
              dob: '1992-12-01T00:00:00Z',
              image: 'https://i.pinimg.com/736x/3f/9d/f4/3f9df48174e0f6d7ba84d50cea92105c--hot-anime-anime-guys.jpg',
              married: false,
              age: 20,
              email: 'mamura.daiki@hnr.com'
            }
          ]
        end
      end
    end
  end

  describe '#update' do
    subject(:update_user) { put "api/v1/users/#{user_id}", request_body.to_json }

    let(:user_id) { Faker::Code.asin }
    let(:base_params) do
      {
        age: 25,
        email: 'suzume.yosano@gmail.com'
      }
    end

    let(:request_body) { base_params }

    context 'when user does not exist' do
      include_examples 'Resource not found', 'user' do
        let(:error_message) { 'user not found' }
      end
    end

    context 'when user exists' do
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
      let(:user) { FactoryGirl.create(:user, user_attributes) }

      before { user }

      include_context 'when provided user parameters are invalid'

      context 'when provided user parameters are valid' do
        let(:user_body) { JSON.parse(update_user.body) }

        let(:user_response) do
          {
            id: user_id,
            name: 'Suzume Yosano',
            dob: '1992-12-01T00:00:00Z',
            image: 'http://pm1.narvii.com/6282/0592a2f2698b13caa17546344c9e9553071aea7a_00.jpg',
            married: false,
            age: 25,
            email: 'suzume.yosano@gmail.com'
          }
        end

        it "updates user's age" do
          expect(user_body['age']).to eq(25)
        end

        it "updates user's email" do
          expect(user_body['email']).to eq('suzume.yosano@gmail.com')
        end

        include_examples 'Serving a Resource', 'user' do
          let(:response_body) { user_response.with_indifferent_access }
        end
      end
    end
  end

  describe '#destroy' do
    subject(:destroy_user) { delete "api/v1/users/#{user_id}" }

    let(:user_id) { Faker::Code.asin }

    context 'when user does not exist' do
      include_examples 'Resource not found', 'user' do
        let(:error_message) { 'user not found' }
      end
    end

    context 'when user exists' do
      let(:user) do
        FactoryGirl.create(:user, uid: user_id)
      end

      before { user }

      context 'and delete operation is successful' do
        it 'deletes user' do
          expect { destroy_user }.to change { User.count }.by(-1)
        end

        include_examples 'Success with no content', 'user'
      end

      context 'and delete operation is unsuccessful' do
        before do
          allow(User).to receive(:find_by).with(uid: user_id).and_return(user)
          allow(user).to receive(:destroy!).and_raise('ActiveRecord::RecordNotFound')
        end

        it 'does not delete user' do
          expect { destroy_user }.to change { User.count }.by(0)
        end

        include_examples 'Validate Response', 500, 'returns internal server error' do
          let(:response_body) do
            {
              message: 'Internal server error'
            }
          end
        end
      end
    end
  end
end
