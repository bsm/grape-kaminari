require "grape"
require "grape/kaminari/version"
require "grape/kaminari/max_value_validator"

module Grape
  module Kaminari
    def self.included(base)
      base.class_eval do
        helpers do
          def paginate(collection)
            collection.page(params[:page].to_i).per(params[:per_page].to_i).padding(params[:offset].to_i).tap do |data|
              header "X-Total",       data.total_count.to_s
              header "X-Total-Pages", data.total_pages.to_s
              header "X-Per-Page",    data.limit_value.to_s
              header "X-Page",        data.current_page.to_s
              header "X-Next-Page",   data.next_page.to_s
              header "X-Prev-Page",   data.prev_page.to_s
              header "X-Offset",      params[:offset].to_s
            end
          end
        end

        def self.paginate(options = {})
          options.reverse_merge!(
            per_page: ::Kaminari.config.default_per_page || 10,
            max_per_page: ::Kaminari.config.max_per_page,
            offset: 0
          )
          params do
            optional :page,     type: Integer, default: 1,
                                desc: 'Page offset to fetch.'
            optional :per_page, type: Integer, default: options[:per_page],
                                desc: 'Number of results to return per page.',
                                max_value: options[:max_per_page]
            if  options[:offset].is_a? Numeric
              optional :offset, type: Integer, default: options[:offset],
                                desc: 'Pad a number of results.'
            end
          end
        end
      end
    end
  end
end
