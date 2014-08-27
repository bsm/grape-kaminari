require 'spec_helper'

class PaginatedAPI < Grape::API
  include Grape::Kaminari

  paginate
  get '' do
    paginate(Kaminari.paginate_array((1..10).to_a))
  end

  paginate offset: false
  get 'no-offset' do
    paginate(Kaminari.paginate_array((1..10).to_a))
  end
end

describe Grape::Kaminari do
  subject { PaginatedAPI.new }
  def app; subject; end
  let(:json) { JSON.parse(last_response.body) }
  let(:header) { last_response.header }

  describe 'paginated helper' do

    it 'returns the first page' do
      get '/', page: 1, per_page: 3
      expect(json).to eq [1, 2, 3]
    end

    it 'returns the second page' do
      get '/', page: 2, per_page: 3
      expect(json).to eq [4, 5, 6]
    end

    # This is here to ensure that Kaminari can handle `padding(false)`
    # and still do the right thing.
    it 'works when offset is false' do
      get '/no-offset', page: 1, per_page: 3
      expect(json).to eq [1, 2, 3]
    end

    it 'sets headers' do
      get '/', page: 3, per_page: 2, offset: 1
      expect(header['X-Total']).to eq '10'
      expect(header['X-Total-Pages']).to eq '5'
      expect(header['X-Per-Page']).to eq '2'
      expect(header['X-Page']).to eq '3'
      expect(header['X-Next-Page']).to eq '4'
      expect(header['X-Prev-Page']).to eq '2'
      expect(header['X-Offset']).to eq '1'
    end

  end


end
