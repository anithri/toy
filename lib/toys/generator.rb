module Toys
  module Generators
  end

  class Generator
    attr_reader = :named_list, :catch_list
    def initialize(toy, auto_discover)
      @named_list = {}
      @catch_list = {}
      @toy = toy
    end

    def from(generator,opts, defer_ok = false)
      return generator                       if is_generator_instance?(generator)
      return named_generator(generator,opts) if is_named?(generator)
      return catch_generator(generator,opts) if is_catchable?(generator)
      return generator                       if defer_ok #useful during initialization
      raise StandardError, "No generators found for #{generator.class}(#{generator.inspect}"
    end

    def register_catcher(catch_klass, generator, raise_on_redefine = false)
      if raise_on_redefine && catch_list.has_key?(catch_klass)
        raise "Redefining #{catch_klass} catcher #{generator} for Toys::Generator"
      end
      catch_list[catch_klass] = generator
    end

    def register_named(name, generator, raise_on_redefine = false)
      name = name.intern unless name.is_a?(Symbol)
      if raise_on_redefine && named_list.has_key?(name)
        raise "Redefining named generator #{name.inspect} => #{generator} for Toys::Generator"
      end
      named_list[name] = generator
    end

    def is_generator_instance?(generator)
      generator.respond_to?(:toy_generator?) && generator.toy_generator?
    end

    def is_named?(generator)
      generator.is_a?(Symbol) && named_list.has_key?(generator)
    end

    def is_catchable?(generator)
      catch_list.has_key?(generator.class)
    end

    def named_generator(generator, opts)
      named_list[generator].new(generator, opts)
    end

    def catch_generator(generator, opts)
      catch_list[generator.klass].new(generator,opts)
    end
  end
end
