require 'pathname'

$code_files = ['.java','.cs','.c','.cpp','.h']
$generated_code_file = ['.g.cs', 'g.i.cs', 'TemporaryGeneratedFile']
$c_family = [';', '{', '}']

def should_skip(filename)
  is_not_a_code_file(filename) || contains_generated_code(filename)
end

def is_not_a_code_file(filename)
  !$code_files.include?(File.extname(filename))
end

def contains_generated_code(filename)
  $generated_code_file.any? { |w| filename.include?(w) }
end

def get_all_files(dir)
  files = []

  Pathname(dir).find do |path|
    unless path == dir
      files << path if path.file?
    end
  end
  files
end

def signature(filename)
  count = 0
  interesting_chars = ""

  file = File.open(filename)

  file.each do |line|
    count = count + 1
    line.each_char do |char|
      if ($c_family.include?(char))
        interesting_chars = interesting_chars + char
      end
    end
  end

  "#{filename.basename} (#{count}) #{interesting_chars}"
end


files = get_all_files(ARGV[0])
files.each do |file|
  unless should_skip(file.basename.to_s)
    puts signature(file)
  end
end