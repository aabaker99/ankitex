require 'ankitex'
require './test_util'
include Ankitex::TestUtil
if $0 == __FILE__
  desc = "Test that parser returns correct output"
  latex_path = "./sample.tex" # @todo directory for test data
  expected_front = "Definition 1.2.1 Sigma Algebra"
  expected_back = "A collection of subsets of $S$ is called a \\emph{sigma algebra} (or \\emph{Borel field}) denoted by $\\mathcal{B}$, if it satisifes the following three properties:
\\begin{enumerate}
\\item $\\emptyset \\in \\mathcal{B}$
\\item If $A \\in \\mathcal{B}$, then $A^c \\in \\mathcal{B}$
\\item If $A_1, A_2 \\ldots \\in \\mathcal{B}$, then $\\cup_{i=1}^{\\infty} \\in \\mathcal{B}$
\\end{enumerate}"

  test = nil
  begin
    parser = Ankitex::Parser.new()
    objs = parser.parse_tex(latex_path)
    if(objs.size == 1)
      obj = objs.first
      test_front = test_str_equals?(obj[:front].strip, expected_front.strip)
      test_back = test_str_equals?(obj[:back].strip, expected_back.strip)
      test = (test_front and test_back)
    else
      test = false
    end
  rescue => err
    $stderr.puts "#{err.class}: #{err.message}\n#{err.backtrace.join("\n")}"
    test = "error"
  end

  $stdout.puts "#{desc}... #{test.to_s}"
end
