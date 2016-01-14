module Ankitex
  # Default parser for LaTeX 
  # @todo ignore \newcommand definitions
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

    # Append ch to str, terminate when an outer pair of braces is completed;
    #   Utility function used by parse_tex to identify the initial {theorem-title}
    #   and also the final {theorem-text}: 
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
  end
end
