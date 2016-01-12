module Ankitex
  # Default parser for LaTeX 
  class Parser
    
    # parser state enum
    NULL = 0
    TITLE = 1
    TITLE_DONE = 2
    TEXT = 3
    TEXT_DONE = 4

    # This parser constructs flashcard objects from LaTeX strings of the form
    #   \theorem{title}{
    #     theorem-text
    #     ...
    #   }
    # @return [Array<Hash>] list of flashcard objects with keys
    #   :front [String] Anki flashcard front (theorem title)
    #   :back [String] Anki flashcard back (theorem-text)
    def parse_tex(tex_path)
      rv = []
      File.open(tex_path) { |fh|
        contents = fh.read()
        invocations = contents.split("\\theorem")
        invocations[1..-1].each { |invocation|
          obj = { :front => "", :back => "" }
          depth = 0
          state = NULL
          invocation.each_char { |ch|
            case state
            when NULL
              if(ch == "{")
                state = TITLE
                depth += 1
              end
            when TITLE
              obj[:front], state, depth = append_section(obj[:front], ch, state, depth)
              if(state == NULL)
                state = TITLE_DONE
              end
            when TITLE_DONE
              if(ch == "{")
                state = TEXT
                depth += 1
              end
            when TEXT
              obj[:back], state, depth = append_section(obj[:back], ch, state, depth)
              if(state == NULL)
                state = TEXT_DONE
              end
            when TEXT_DONE
              break
            else
              raise "Invalid state"
            end
          }
          if(obj[:front].empty? or obj[:back].empty?)
            # incomplete object, perhaps definition of \theorem command
            $stderr.puts "Incomplete definition at \\theorem invocation #{invocation.inspect}"
          else
            rv << obj
          end
        }
      }
      return rv
    end

    def append_section(str, ch, state, depth)
      if(ch == "{")
        depth += 1
        str << ch
      elsif(ch == "}")
        depth -= 1
        if(depth == 0)
          state = NULL
        else
          str << ch
        end
      else
        str << ch
      end
      return [str, state, depth]
    end
    
    # To import plain text files into Anki:
    #   (1) fields (e.g. "front" and "back")  must be separated by ";"  
    #   (2) latex must be enclosed in [latex] [/latex] tags
    #   (3) fields that span multiple lines must be quoted
    #   (4) Files must end in a valid extension of which .txt is one
    # @param [Hash] tex_obj @see parse_tex
    # @return [String] an Anki record that can be imported
    # @todo sanitize obj[:back] from '"' and "[latex]"
    def self.tex_to_anki(tex_obj)
      obj = Marshal.load(Marshal.dump(tex_obj))
      obj[:back] = "\"[latex]#{obj[:back]}[/latex]\""
      return "#{obj[:front]};#{obj[:back]}"
    end
    
    def self.out_path(in_path)
      ext = ".anki.txt"
      dirname = File.dirname(filepath)
      extname = File.extname(filepath)
      basename = File.basename(filepath, extname)
      return File.join(dirname, basename + ext)
    end
    
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
