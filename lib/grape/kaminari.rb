require "grape/kaminari/version"
require "grape/kaminari/max_value_validator"
require "kaminari/grape"

module Grape
  module Kaminari
    def self.included(base)
      base.class_eval do
        helpers do
          def paginate(collection)
            collection.page(params[:page]).per(params[:per_page]).tap do |data|
              header "X-Total",       data.total_count.to_s
              header "X-Total-Pages", data.num_pages.to_s
              header "X-Page",        data.current_page.to_s
              header "X-Per-Page",    params[:per_page].to_s
            end
          end
        end

        def self.paginate(options = {})
          options.reverse_merge!(
            per_page: 10,
            max_per_page: false
          )
          params do
            optional :page,     type: Integer, default: 1,
                                desc: 'Page offset to fetch.'
            optional :per_page, type: Integer, default: options[:per_page],
                                desc: 'Number of results to return per page.',
                                max_value: options[:max_per_page]
          end
        end
      end
    end
  end
end
