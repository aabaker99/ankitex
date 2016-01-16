require './test_util'
include Ankitex::TestUtil
if $0 == __FILE__
  test = false
  desc = "Test that Anki flashcard file is produced with correct data"
  test_file = "sample.tex"
  target_file = "sample.anki.txt"
  target_bak = "sample.anki.txt.bak"
  # @todo flashcard front will change soon
  expected_contents = <<EOS
Definition 1.2.1 Sigma Algebra;"[latex]
A collection of subsets of $S$ is called a \\emph{sigma algebra} (or \\emph{Borel field}) denoted by $\\mathcal{B}$, if it satisifes the following three properties:
\\begin{enumerate}
\\item $\\emptyset \\in \\mathcal{B}$
\\item If $A \\in \\mathcal{B}$, then $A^c \\in \\mathcal{B}$
\\item If $A_1, A_2 \\ldots \\in \\mathcal{B}$, then $\\cup_{i=1}^{\\infty} \\in \\mathcal{B}$
\\end{enumerate}
[/latex]"
EOS
  begin
    if(File.exists?(target_file))
      if(File.exists?(target_bak))
        raise "Refusing to run test which may overwrite your data! Please remove #{target_file} and #{target_bak} from the test directory"
      end
      File.rename(target_file, target_bak)
    end
    `ankitex -o #{target_file} #{test_file}` # @todo fix install bin
    if($?.exitstatus != 0)
      raise "Command failed"
    end
    if(File.exists?(target_file))
      test = test_str_equals?(File.read(target_file), expected_contents)
      File.delete(target_file) # clean up
    else
      test = false
    end
  rescue => err
    $stderr.puts "#{err.class}: #{err.message}\n#{err.backtrace.join("\n")}"
    test = "error"
  end
  $stdout.puts "#{desc}... #{test.to_s}"
end
