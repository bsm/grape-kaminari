module Grape
  module Kaminari
    base = if post_0_9_0_grape?
             Grape::Validations::Base
           else
             Grape::Validations::SingleOptionValidator
           end

    class MaxValueValidator < base
      def validate_param!(attr_name, params)
        return unless params[attr_name]

        attr = params[attr_name]
        if attr && @option && attr > @option
          if Gem::Version.new(Grape::VERSION) >= Gem::Version.new('0.9.0')
            raise Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: "must be less than #{@option}"
          else
            raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "must be less than #{@option}"
          end
        end
      end
    end
  end
end
