module Grape
  module Kaminari
    class MaxValueValidator < Grape::Validations::Validators::Base
      def validate_param!(attr_name, params)
        attr = params[attr_name]
        return unless attr.is_a?(Integer) && @option && attr > @option

        raise Grape::Exceptions::Validation.new(
          params: [@scope.full_name(attr_name)],
          message: "must be less than or equal #{@option}",
        )
      end
    end
  end
end
