module Toys
  module Containers
    class Base

      def self.register_as(*names)
        Toys::Containers::Tracker.instance.register_names(names, self)
      end

      def make(*args)
        raise NotImplementedError,"ALl Toys::Containers compliant classes must implement #make(*args)"
      end

      def toy_methods
      end

      def container_methods
      end

    end
  end
end