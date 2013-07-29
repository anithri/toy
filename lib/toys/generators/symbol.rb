require 'koremu'

module Toys
  module Generators
    # a Toys::Generators class that uses a BASE_LIST and random symbols to generate symbols
    class Symbol < Base
      DEFAULT_MODEL = :symbol

      # define extra name keys to account for catches on this oddball
      CATCH_ON_KEYS = [:s,:sym,:symbol,:symbols]

      # a base list of symbols that I happened to think was useful.
      #   If you think better assign your own values as so
      # @example empty BASE_LIST
      #   Toys::Generators::Symbol::BASE_LIST.clear #clears all entries
      # @example add new elements to BASE_LIST
      #   # Add a single symbol
      #   Toys::Generators::Symbol::BASE_LIST << :my_symbol
      #   # Add an array of symbols
      #   extra_symbols = [:another_sym_ome,:another_sym_too]
      #   Toys::Generators::Symbol::BASE_LIST += extra_symbols
      BASE_LIST = [:foo, :bar, :baz, :qux, :quux,
                   :corge, :grault, :garply, :waldo, :shiny,
                   :plugh, :xyzzy, :thud, :rfc, :wibble,
                   :wobble, :wubble, :fred, :flob, :gorram]

      # returns a single value at random from the BASE_LIST array
      # unlike in other Toys::Generators, the @model paramter has no effect on symbol generation
      #  and is present to ensure compliance with implied Toys::Generators interface
      def kick
        BASE_LIST[rng.rand(BASE_LIST.length)]
      end

      # returns a number of values selected at random from the BASE_LIST and
      #   additional symbols generated at random using koremu strings of 1 to 3 syllables.
      #   BASE_LIST symbols will always be used to generate as many symbols as it can, while the
      #   random symbols are used as filler to cover the case when num is bigger than the number of
      #   symbols in BASE_LIST
      # @see http://www.ruby-doc.org/gems/docs/k/koremutake-0.1.0/README.html koremu Documentation
      # @param [Fixnum] size the number of elements to return
      # @raise [ArgumentError] if the size is not a Fixnum
      # @return [Array<Symbol>] an array of symbols
      def take(size)
        raise ArgumentError, "size is not a Fixnum" unless size.is_a?(::Fixnum)
        results = BASE_LIST
        results += take_random(num - BASE_LIST.count) if num > BASE_LIST.count
        results.shuffle.take(num)
      end

      private
      def take_random(num)
        Array.new(num){template_to_word(rng.rand(1..3))}
      end

      def template_to_word(template)
        KoremuArray.new(Array.new(template){rng.rand(0..128)}).to_ks
      end

    end
  end
end
Toys::Generators::Symbol::CATCH_ON_KEYS.each do |name|
  Toys::MasterToy.instance.name_generator(name, Toys::Generators::Symbol, false)
end
Toys::MasterToy.instance.catcher_generator(Symbol, Toys::Generators::Symbol, false)
