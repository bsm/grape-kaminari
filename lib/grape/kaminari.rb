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

      def paginate(collection, without_count: false)
        coll = collection.page(params[:page].to_i)
                         .per(params[:per_page].to_i)
                         .padding(params[:offset].to_i)
        coll = coll.without_count if without_count && coll.respond_to?(:without_count)

        unless without_count
          header 'X-Total', coll.total_count.to_s
          header 'X-Total-Pages', coll.total_pages.to_s
        end
        header 'X-Per-Page',    coll.limit_value.to_s
        header 'X-Page',        coll.current_page.to_s
        header 'X-Next-Page',   coll.next_page.to_s
        header 'X-Prev-Page',   coll.prev_page.to_s
        header 'X-Offset',      params[:offset].to_s

        coll
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
