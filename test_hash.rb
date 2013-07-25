require 'koremu'
class Toy

  def initialize
    @rng = Random.new
  end

  def mk_hash(*args)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    key,value,n = :sym, "hello", 10
    case args.count
      when 1
        n = args.first
      when 2
        key = args.first
        value = args.last
      when 3
        key,value,n = args
      else
    end
    key_list =  Generators.const_get(key  .class.to_s).list(key  ,n,opts)
    value_list =Generators.const_get(value.class.to_s).list(value,n,opts)
    key_list.zip(value_list).inject({}){|h,a| h[a[0]] = a[-1];h}
  end

  def mk_list(type = 20, n = 10, opts = {})
    Generators.const_get(type.class.to_s).list(type,n,opts)
  rescue TypeError
    raise ArgumentError, "No Toy::Generators::#{type.class} found."
  end

  def mk_scalar(type, opts = {})
    self.mk_list(type,1,opts).first
  end

  private

  module Generators
    class Fixnum
      def self.list(origin,n,opts)
        max = origin <= 20 ? 20 : 10 ** Math.log10(origin).to_i
        Array.new(n){Random.new.rand(1..max)}
      end
    end

    class String
      include Enumerable

      def initialize(model,opts)
        @model = model
        @opts = opts
      end

      def each
        mk_phrase
      end


      def mk_phrase
        word_model.map{|w| word_from_model(w)}.join(" ").capitalize
      end

      def word_model
        @word_map ||= @origin.split(" ").map{|e| map_from_word(e)}
      end

      def map_from_word(word)
        ((10 ** word.length/2.5).ceil * 1.25).to_i
      end

      def self.word_from_model(scale)
        KoremuFixnum.new(Random.new.rand(scale)).to_ks
      end
    end

    class Symbol
      def self.list(origin,n,opts)
        return COMBO_LIST[origin.to_s.split("_").count].take(n).to_a
      end

      def self.lazy_list(n)
        BASE_LIST.combination(n).to_a.shuffle.lazy.map{|a| a.map(&:to_s).join("_").intern}
      end
    end

    class String

      def self.list(origin,n,opts)

      end
    end


  end
end




