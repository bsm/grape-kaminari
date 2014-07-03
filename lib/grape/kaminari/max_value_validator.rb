
require "grape"
module Grape
  module Kaminari
    class MaxValueValidator < Grape::Validations::SingleOptionValidator
      def validate_param!(attr_name, params)
        return unless params[attr_name]

        attr = params[attr_name]
        if attr && @option && attr > @option
          raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "must be less than #{@option}"
        end
      end
    end
  end
end
