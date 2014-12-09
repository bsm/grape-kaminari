module Grape
  module Kaminari
    class << self
      def post_0_9_0_grape?
        Gem::Version.new(Grape::VERSION) > Gem::Version.new('0.9.0')
      end
    end
  end
end

require "grape/kaminari"
