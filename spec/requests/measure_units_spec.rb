require 'rails_helper'

RSpec.describe 'Measure Units API', type: :request do
  # Initialize authorization header
  let(:user_id) { Faker::Number.digit }
  let(:headers) { valid_headers }

  # Initialize test data
  let!(:measure_units) { create_list(:measure_unit, 10) }
  let(:measure_unit_id) { measure_units.first.id }

  describe 'GET /api/measure_units' do
    before { get '/api/measure_units', params: {}, headers: headers }

    it 'returns measure_units' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/measure_units/:measure_unit_id' do
    before { get "/api/measure_units/#{measure_unit_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the measure_unit' do
        expect(json).not_to be_empty
        expect(json['data']['id']).to eq(measure_unit_id.to_s)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      let(:measure_unit_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /api/measure_units' do
    let(:valid_attributes) { {name: 'First', acronym: '1ST'} }

    context 'when the request is valid' do
      before { post '/api/measure_units', params: valid_attributes, headers: headers }

      it 'creates a measure_unit' do
        expect(json['data']['attributes']['name']).to eq('First')
        expect(json['data']['attributes']['acronym']).to eq('1ST')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/measure_units', params: {name: 'Fail'}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /api/measure_units/:measure_unit_id' do
    let(:valid_attributes) { {name: 'Second', acronym: '2ND'} }

    context 'when the record exists' do
      before { put "/api/measure_units/#{measure_unit_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /api/measure_units/:measure_unit_id' do
    before { delete "/api/measure_units/#{measure_unit_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
