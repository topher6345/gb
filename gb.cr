require "io/console"

class String
  def colorize(color)
    case color
    when :blue  then "\e[0;34;49m#{self}\e[0m"
    when :green then "\e[0;32;49m#{self}\e[0m"
    else
      self
    end
  end

  def on_yellow
    "\e[0;39;43m#{self}\e[0m"
  end

  def uncolorize
    str = String.new
    scan_for_colors.each do |match|
      str = str + match[3]
    end
    str
  end

  def scan_for_colors
    scan(/\033\[([0-9;]+)m(.+?)\033\[0m|([^\033]+)/m).map do |match|
      split_colors(match)
    end
  end

  def split_colors(match)
    colors = (match[0] || "").split(";")
    array = ["", "", "", ""]
    array[0], array[1], array[2] = colors if colors.size == 3
    # puts colors.class
    array[1] = colors.first if colors.size == 1
    array[3] = match[1] || match[2]
    array
  end
end

branches = `git branch  --sort=-committerdate | head -n 13 | sort`.split("\n")
branch_count = branches.size
current_branch = `git branch`.split("\n").select { |s| s.match(/\*/) }.first[2..-1]
current_position = branches.index { |s| s.match(/#{current_branch}/) }
branches.map! { |o| o.size > 0 ? o[2..-1] : o }
puts current_position
# Mark current branch in blue
exit(45) if current_position.nil?
# branches[current_position] = branches[current_position].colorize(:blue)

begin_position = current_position

def draw(current_position, branches, begin_position)
  system("clear")
  return if branches.nil?
  branches.each_with_index do |tail, index|
    if (index == current_position) && begin_position == current_position
      puts(("* " + tail).colorize(:blue))
    elsif (index == current_position) && begin_position != current_position
      puts(("* " + tail).colorize(:green))
    else
      puts "  " + tail
    end
  end
  exit(1) if begin_position.nil?
  exit(1) if current_position.nil?
  puts "git branch " + branches[begin_position].dup.colorize(:blue) +
       " → " + branches[current_position].dup.colorize(:green)
  puts "\n"
  puts branches[current_position]
  commit_message = `git show -s --format=%B #{branches[current_position]} | cat`
  puts commit_message.colorize(:black).on_yellow
end

draw(current_position, branches, begin_position)
loop do
  case STDIN.raw(&.read_char)
  when 'j'
    exit(23) if current_position.nil?
    current_position < branch_count - 1 ? (current_position += 1) : 0
  when 'k'
    exit(38) if current_position.nil?
    current_position > 0 ? (current_position -= 1) : 0
  when 'q'
    exit(0)
  when '\r'
    break
  else
    exit(1)
  end
  draw(current_position, branches, begin_position)
end

exit(1) if current_position.nil?
puts `git checkout #{branches[current_position]}`
