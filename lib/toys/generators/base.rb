module Toys
  module Generators
    class Base

      # creates a new instance of class. see kick method to understand model and generation
      # @param [String] model string to base the random generation off of, defaults to DEFAULT_MODEL
      def initialize(model)
        @model = model || DEFAULT_MODEL
      end

      # @abstract Subclass and override {#kick} to implement
      #   a custom Toys::Generators class.
      def kick
        raise NotImplementedError, "Any Toys::Generators compliant class must implement #kick"
      end

      # returns an array containing values generated with #kick method
      # @param [Fixnum] size the number of elements to generate
      # @raise [ArgumentError] if the size is not a Fixnum
      # @return [Array] array of generated values
      def take(size)
        raise ArgumentError, "size is not a Fixnum" unless size.is_a?(::Fixnum)
        ::Array.new(size){kick}
      end

      # always returns true so the default generators can be used as other generator classes are.
      # @return [true]
      def toy_generator?
        true
      end

      protected
      def rng
        @rng ||= Random.new
      end
    end
  end
end