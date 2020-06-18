require 'spec_helper'

class UnPaginatedAPI < Grape::API
  # Intentionally not including Grape::Kaminari
end

class PaginatedAPI < Grape::API
  include Grape::Kaminari
end

describe Grape::Kaminari do
  describe 'unpaginated api' do
    subject { Class.new(UnPaginatedAPI) }

    it 'raises an error' do
      expect { subject.paginate }.to raise_error(NoMethodError, /undefined method `paginate' for/i)
    end
  end

  describe 'default paginated api' do
    subject { Class.new(PaginatedAPI) }

    it 'adds to declared parameters' do
      subject.paginate
      expect(subject.inheritable_setting.route[:declared_params]).to eq(%i[page per_page offset])
    end

    describe 'descriptions, validation, and defaults' do
      let(:params) { subject.routes.first.params }

      before do
        subject.paginate
        subject.get('/') {}
      end

      it 'does not require :page' do
        expect(params['page'][:required]).to eq(false)
      end

      it 'does not require :per_page' do
        expect(params['per_page'][:required]).to eq(false)
      end

      it 'does not require :offset' do
        expect(params['offset'][:required]).to eq(false)
      end

      it 'describes :page' do
        expect(params['page'][:desc]).to eq('Page offset to fetch.')
      end

      it 'describes :per_page' do
        expect(params['per_page'][:desc]).to eq('Number of results to return per page.')
      end

      it 'describes :offset' do
        expect(params['offset'][:desc]).to eq('Pad a number of results.')
      end

      it 'validates :page as Integer' do
        expect(params['page'][:type]).to eq('Integer')
      end

      it 'validates :per_page as Integer' do
        expect(params['per_page'][:type]).to eq('Integer')
      end

      it 'validates :offset as Integer' do
        expect(params['offset'][:type]).to eq('Integer')
      end

      it 'defaults :page to 1' do
        expect(params['page'][:default]).to eq(1)
      end

      it 'defaults :per_page to Kaminari.config.default_per_page' do
        expect(params['per_page'][:default]).to eq(::Kaminari.config.default_per_page)
      end

      it 'defaults :offset to 0' do
        expect(params['offset'][:default]).to eq(0)
      end
    end
  end

  describe 'custom paginated api' do
    subject { Class.new(PaginatedAPI) }
    let(:app) { subject }
    let(:params) { subject.routes.first.params }

    before do
      subject.paginate per_page: 99, max_per_page: 999, offset: 9
      subject.get('/') {}
    end

    it 'defaults :per_page to customized value' do
      expect(params['per_page'][:default]).to eq(99)
    end

    it 'succeeds when :per_page is within :max_value' do
      get('/', page: 1, per_page: 999)
      expect(last_response.status).to eq(200)
    end

    it 'ensures :per_page is within :max_value' do
      get('/', page: 1, per_page: 1_000)
      expect(last_response.status).to eq(400)
      expect(last_response.body).to match(/per_page must be less than or equal 999/)
    end

    it 'ensures :per_page is numeric' do
      get('/', page: 1, per_page: 'foo')
      expect(last_response.status).to eq(400)
      expect(last_response.body).to match(/per_page is invalid/)
    end

    it 'defaults :offset to customized value' do
      expect(params['offset'][:default]).to eq(9)
    end
  end

  describe 'paginated api without :offset' do
    subject { Class.new(PaginatedAPI) }

    it 'excludes :offset from declared params' do
      subject.paginate offset: false
      expect(subject.inheritable_setting.route[:declared_params]).not_to include(:offset)
    end
  end
end
