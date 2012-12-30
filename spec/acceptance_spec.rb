require "spec_helper"

some = Some("test")
upcase = lambda { |v| Some(v.upcase) }
empty  = lambda { |v| None }

describe "Option" do

  describe "when applying the 3 monadic axioms" do

    describe "left identity" do

      it "obeys (return x) >>= f == f x" do
        some.flat_map(&upcase).must_equal(upcase.call(some.get))
      end
    end

    describe "right identity" do

      it "obeys m >>= return == m" do
        some.flat_map { |v| Some(v) }.must_equal(some)
      end
    end

    describe "associative composition" do

      it "obeys (m >>= f) >>= g == m >>= (\\x -> f x >>= g)" do
        some.flat_map(&upcase).flat_map(&empty).
          must_equal(upcase.call(some.get).flat_map(&empty))
      end
    end
  end
end
