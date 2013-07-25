module Toys
  module Containers
    # A Toys::Container class that returns an array
    class Array

      # @!attribute [r] default_model
      #   @return [Object] default model used if mk_array called with no options, defaults to 100
      # @!attribute [r] default_size
      #   @return [Fixnum] default size of array returned from mk_array, defaults to 10
      attr_reader :default_model, :default_size

      # creates a new instance of class with default values
      def initialize
        @default_model = 100
        @default_size = 10
      end

      # Sets default_values for object
      # @param [Object] model value to set default_model to
      # @param [Fixnum] size value to set default_size to
      # @raise [ArgumentError] if size is not a Fixnum
      # @return [void]
      def defaults(model, size)
        raise ArgumentError, "size is not a Fixnum" unless size.is_a?(Fixnum)
        @default_model = model
        @default_size = size
      end

      # generates an array containing size elements of generator output
      # @param [#take] generator generator used to fill array
      # @param [Fixnum] size size of array to fill
      # @raise [ArgumentError] if size is not a Fixnum
      # @return [Array<Generated>] Array of results of generator
      def contains(generator, size)
        size ||= default_size
        raise ArgumentError, "size is not a Fixnum" unless size.is_a?(Fixnum)
        generator.take(size)
      end
    end
  end
end

Toy.register_container(:array,Toys::Containers::Array.new)