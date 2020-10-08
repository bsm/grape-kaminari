require 'grape'
require 'grape/kaminari/version'
require 'grape/kaminari/max_value_validator'
require 'kaminari/grape'

module Grape
  module Kaminari
    extend ActiveSupport::Concern

    included do
      helpers HelperMethods
    end

    module HelperMethods # :nodoc:
      extend Grape::API::Helpers

      params :pagination do |opts = {}|
        opts.reverse_merge!(
          per_page: ::Kaminari.config.default_per_page || 10,
          max_per_page: ::Kaminari.config.max_per_page,
          offset: 0,
        )

        optional :page, type: Integer, default: 1,
                        desc: 'Page offset to fetch.'
        optional :per_page, type: Integer, default: opts[:per_page],
                            desc: 'Number of results to return per page.',
                            max_value: opts[:max_per_page]

        if opts[:offset].is_a?(Integer)
          optional :offset, type: Integer, default: opts[:offset],
                            desc: 'Pad a number of results.'
        end
      end

      def paginate(collection)
        collection.page(params[:page].to_i)
                  .per(params[:per_page].to_i)
                  .padding(params[:offset].to_i)
                  .tap do |data|
          header 'X-Total',       data.total_count.to_s
          header 'X-Total-Pages', data.total_pages.to_s
          header 'X-Per-Page',    data.limit_value.to_s
          header 'X-Page',        data.current_page.to_s
          header 'X-Next-Page',   data.next_page.to_s
          header 'X-Prev-Page',   data.prev_page.to_s
          header 'X-Offset',      params[:offset].to_s
        end
      end
    end

    module DSLMethods # :nodoc:
      def paginate(opts = {})
        params do
          use(:pagination, opts)
        end
      end
    end
    Grape::API::Instance.extend(DSLMethods)
  end
end
