require 'spec_helper'

describe Toy do
  context "Integration Tests" do
    subject { Toy }

    it { subject.should eq Toys::MasterToy.instance }
    it {subject.containers.should match_array [:array,:hash,:value]}
    it {subject.generators.should match_array [:fixnum,:symbol,:sym,:s,:string,:rand_range,:symbols]}
    it {subject.catchers.should match_array [Fixnum, String, Symbol]}

    describe "added methods" do
        let(:added_methods){
          [
              "mk_#{container}".intern
          ]
        }
      context "for array" do
        let(:container){"array"}
        it{binding.pry;subject.methods.should include *added_methods}
      end
      context "for HASH" do
        let(:container){"hash"}
        it{subject.methods.should include *added_methods}
      end
      context "for value" do
        let(:container){"value"}
        it{subject.methods.should include *added_methods}
      end
    end



    context "return an array with 13 random numbers between 1 and 20 " do
      let(:toy_array){Toy.mk_array(1,13)}
      #it{toy_array.count.should eq 13}
      #it{binding.pry;toy_array.max.should be <= 20}
      #it{toy_array.max.should be >= 1}
    end
  end
end
