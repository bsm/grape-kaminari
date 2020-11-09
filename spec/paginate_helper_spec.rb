require 'spec_helper'
require 'json'

class PaginatedAPI < Grape::API
  include Grape::Kaminari

  params do
    use :pagination
  end
  get '' do
    paginate(Kaminari.paginate_array((1..10).to_a))
  end

  params do
    use :pagination, offset: false
  end
  get 'no-offset' do
    paginate(Kaminari.paginate_array((1..10).to_a))
  end

  params do
    use :pagination, offset: false
  end
  get 'no-count' do
    paginate(Kaminari.paginate_array((1..10).to_a), without_count: true)
  end

  resource :sub do
    params do
      use :pagination, per_page: 2
    end
    get '/' do
      paginate(Kaminari.paginate_array((1..10).to_a))
    end
  end
end

describe Grape::Kaminari do
  subject { PaginatedAPI.new }
  let(:app)  { subject }
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

    it 'works without count' do
      get '/no-count', page: 2, per_page: 3
      expect(json).to eq [4, 5, 6]
      expect(header).to include(
        'X-Per-Page' => '3',
        'X-Page' => '2',
        'X-Next-Page' => '3',
        'X-Prev-Page' => '1',
      )
      expect(header).not_to include(
        'X-Total',
        'X-Total-Pages',
      )
    end

    it 'sets headers' do
      get '/', page: 3, per_page: 2, offset: 1
      expect(header).to include(
        'X-Total' => '10',
        'X-Total-Pages' => '5',
        'X-Per-Page' => '2',
        'X-Page' => '3',
        'X-Next-Page' => '4',
        'X-Prev-Page' => '2',
        'X-Offset' => '1',
      )
    end

    it 'can be inherited' do
      get '/sub', page: 1
      expect(json).to eq [1, 2]
    end
  end
end
