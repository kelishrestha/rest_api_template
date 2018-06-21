# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :api do
  describe '#create' do
    subject(:create_user) { post 'api/v1/users', request_body.to_json }

    let(:api_key) { FactoryGirl.create(:api_key) }

    before do
      header 'x-api-token', api_key.token
      header 'Content-type', 'application/json'
    end

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

    context 'when required user parameters are missing' do
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

    context 'when provided user parameters are invalid' do
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

      include_examples 'Serving a Resource', 'user' do
        let(:response_body) { user_response.with_indifferent_access }
      end
    end
  end

  describe '#show' do
    subject(:get_user) { get "api/v1/users/#{user_id}" }

    let(:api_key) { FactoryGirl.create(:api_key) }

    before do
      header 'x-api-token', api_key.token
      header 'Content-type', 'application/json'
    end

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
end
