require 'pry'
module Toys
  module Containers
    # A Toys::Container class that returns an array
    class Array < Base
      register_as :array
      TOY_METHODS = [:make!]

      # @!attribute [r] default_model
      #   @return [Object] default model used if mk_array called with no options, defaults to 100
      # @!attribute [r] default_size
      #   @return [Fixnum] default size of array returned from mk_array, defaults to 10
      attr_reader :default_model, :default_size

      # creates a new instance of class with default values
      def initialize(default_generator = 100, default_size = 10)
        @default_model = default_generator
        @default_size  = default_size
      end

      def make(model = default_model, size = default_size)
        raise ArgumentError, "size is not a Fixnum" unless size.is_a?(Fixnum)
        generator_from(model).take(size)
      end

      def make!(model, size = default_size)
        set_default_model(model)
        @default_size = size
      end

      def generator_from(model)
        Toys::Generators.from(model)
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
        generator.take(size)
      end
    end
  end
end
