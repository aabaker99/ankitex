module Ankitex
  module TestUtil
    def test_str_equals?(observed, expected)
      test = (observed == expected)
      unless(test)
        $stderr.puts "test failed!\nobserved=\n#{observed.inspect}\n!=\nexpected=\n#{expected.inspect}"
      end
      test
    end
  end
end
