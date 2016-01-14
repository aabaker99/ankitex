module Ankitex

  # Transform intermediate, parsed objects into serialized Anki card strings and files
  class Ankier
    # To import plain text files into Anki:
    #   (1) fields (e.g. "front" and "back")  must be separated by ";"  
    #   (2) latex must be enclosed in [latex] [/latex] tags
    #   (3) fields that span multiple lines must be quoted
    #   (4) Files must end in a valid extension of which .txt is one
    # @param [Hash] tex_obj @see [Ankitex::Parser#parse_tex]
    # @return [String] an Anki record that can be imported
    # @todo sanitize obj[:back] from '"' and "[latex]"
    def self.tex_to_anki(tex_obj)
      obj = Marshal.load(Marshal.dump(tex_obj))
      obj[:back] = "\"[latex]#{obj[:back]}[/latex]\""
      return "#{obj[:front]};#{obj[:back]}"
    end
    
    # Save Anki records to a file
    # @param [Array<String] anki_strs anki records to save
    # @param [String] path filepath to save to
    def self.save_anki_file(anki_strs, path)
      rv = nil
      unless(File.exists?(path))
        File.open(path, "w") { |fh|
          anki_strs.each { |anki_str|
            fh.puts(anki_str)
          }
        }
        rv = File.size(path)
      else
        $stderr.puts "Refusing to overwrite existing file #{path.inspect}"
        rv = nil
      end
      return rv
    end
  end
end
