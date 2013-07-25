require "toys/version"
require 'singleton'
require 'forwardable'

module Toys
  #generators are required at the end of the file
  module Generators
  end
  require 'toys/generators/base'

  #containers are required at the end of the file
  module Containers
  end

  # singleton class whose instance is assigned to Toy
  class MasterToy
    include Singleton
    extend Forwardable

    CONTAINER_LIST = {}
    GENERATOR_LIST = {}
    CATCHER_LIST = {}

    # register a container
    # @param [Symbol] name name of the container.  Used for 2 methods given NAME, mk_NAME and NAME_defaults
    # @param [Toys::Containers] klass instance of container class
    # @param [Boolean] raise_on_redefine defaults to false
    # @raise StandardError when a second klass with the same name is registered and if raise_on_redefine is true
    def register_container(name, klass, raise_on_redefine = false)
      raise StandardError, "Redefining Toys::Containers::#{name}" if raise_on_redefine && CONTAINER_LIST.has_key?(name)
      CONTAINER_LIST[name] = klass
      self.class.class_eval <<-EOS
        def mk_#{name}(*args)
          container = CONTAINER_LIST[:#{name}]
          model, size = args
          model ||= container.default_model
          generator = from_model(model)
          container.contains(model,size)
        end
        def #{name}_defaults(*args)
          defaults_for(:#{name}, *args)
        end
      EOS
    end

    def name_generator(name, generator, raise_on_redefine = false)
      if raise_on_redefine && GENERATOR_LIST.has_key?(name)
        raise StandardError, "Redefining #{name.inspect} name for Toys::Generators"
      end
      GENERATOR_LIST[name.intern] = generator
      self.class.class_eval <<-EOS
        def gen_#{name}(model)
          GENERATOR_LIST[:#{name}].new(model)
        end
      EOS
    end

    def catcher_generator(model_class, generator, raise_on_redefine = false)
      if raise_on_redefine && GENERATOR_LIST.has_key?(model_class)
        raise StandardError, "Redefining #{model_class} catcher for Toys::Generators"
      end
      CATCHER_LIST[model_class] = generator
    end

    def from_model(*models)
      out = []
      models.each do |model|
        begin
          (out << model) if model.respond_to?(:toy_generator?) && model.toy_generator?
          (out << GENERATOR_LIST[model]) if model.is_a?(Symbol) && GENERATOR_LIST.has_key?(model)
          (out << CATCHER_LIST[model.class]) if CATCHER_LIST.has_key?(model.class)
        rescue TypeError
          raise ArgumentError, "No Catcher generators found for ::#{model.class}(#{model.inspect})"
        end
      end
    end

    def register_generator(name, klass, case_catcher = false, raise_on_redefine = false)

      GENERATOR_LIST[name] = klass
      CATCHER_LIST[name] = klass if class_catcher
      self.class.class_eval <<-EOS
        def gen_#{name}(model)
          GENERATOR_LIST[name].new(model)
        end
      EOS
    end

    def container_for(container,*args)
      model,size = args
      model ||= CONTAINER_LIST[container].default_model
      generators = model.is_a?(Array) ? model.map{|m| generator_for(m)} : generator_for(model)
      CONTAINER_LIST[container].send(:contains, generators, size)
    end

    def defaults_for(container, *args)
      CONTAINER_LIST[container].send(:defaults, *args)
    end

    # determines the generator to be used based on the model
    # @return [Generator] model if model.respond_to?(:toy_generator?)
    def generator_for(model)
      return model if model.respond_to?(:toy_generator?) && model.toy_generator?
      Toys::Generators.const_get(model.class.to_s).new(model)
    rescue TypeError
      raise ArgumentError, "No Toy::Generators::#{model.class} for #{model.inspect} found."
    end
  end
end

Toy = Toys::MasterToy.instance
require 'toys/generators/fixnum'
require 'toys/generators/string'
require 'toys/generators/symbol'
require 'toys/generators/fixnum_from_range'

require 'toys/containers/array'
require 'toys/containers/hash'
require 'toys/containers/value'
