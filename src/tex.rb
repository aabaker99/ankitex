#!/usr/bin/env ruby

# Parse a tex file by treating the non-blank line after a \begin{document}
#   declaration as the card front and any subsequent lines as the card back
def parse_tex(tex_path)
  rv = nil
  obj = { :front => "", :back => "" }
  re = %r{\\begin\{document\}}
  File.open(tex_path) { |fh|
    lines = fh.readlines.map { |line| line.strip }
    begin_doc_ind = lines.find_index { |line|
      re.match(line)
    }
    unless(begin_doc_ind.nil?)
      obj[:front] = lines[begin_doc_ind+1]
      obj[:back] = lines[begin_doc_ind+2..-1].join("\n")
      rv = obj
    end
  }
  return rv
end

# To import plain text files into Anki:
#   (1) fields (e.g. "front" and "back")  must be separated by ";"  
#   (2) latex must be enclosed in [latex] [/latex] tags
#   (3) fields that span multiple lines must be quoted
#   (4) Files must end in a valid extension of which .txt is one
# @param [Hash] tex_obj @see parse_tex
# @return [String] an Anki record that can be imported
# @todo sanitize obj[:back] from '"' and "[latex]"
def tex_to_anki(tex_obj)
  obj = Marshal.load(Marshal.dump(tex_obj))
  obj[:back] = "\"[latex]#{obj[:back]}[/latex]\""
  return "#{obj[:front]};#{obj[:back]}"
end

def out_path(in_path)
  ext = ".anki.txt"
  dirname = File.dirname(filepath)
  extname = File.extname(filepath)
  basename = File.basename(filepath, extname)
  return File.join(dirname, basename + ext)
end

def save_anki_file(anki_strs, path)
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

# create multiple anki cards
def main(filepaths, outpath)
  parsed_objs = filepaths.map { |filepath| parse_tex(filepath) }
  parsed_objs = parsed_objs.select { |parsed_obj| !parsed_obj.nil? }
  anki_strs = parsed_objs.map { |parsed_obj| tex_to_anki(parsed_obj) }
  rv = save_anki_file(anki_strs, outpath)
end

if $0 == __FILE__
  outpath = ARGV[0]
  filepaths = ARGV[1..-1]
  rv = main(filepaths, outpath)
end
