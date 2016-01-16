Gem::Specification.new { |spec|
  spec.name = "ankitex"
  spec.version = "0.0.1"
  spec.date = "2015-01-15"
  spec.summary = "A gem for making Anki flashcards from TeX files"
  spec.description = spec.summary
  spec.authors = ["Aaron Baker"]
  spec.files = ["bin/ankitex", "lib/ankitex.rb", "lib/ankitex/parser.rb", "lib/ankitex/ankier.rb"]
  spec.bindir = "bin"
  spec.executables << "ankitex"
  spec.license = "MIT"
}
