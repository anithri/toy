require 'spec_helper'

describe Toy do
  subject { Toy }

  it{subject.should eq  ToyGenerator.instance}

end