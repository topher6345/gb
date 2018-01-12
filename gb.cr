require "io/console"

class String
  def blue
    "\e[0;34;49m#{self}\e[0m"
  end

  def red
    "\e[0;31;49m#{self}\e[0m"
  end

  def green
    "\e[0;32;49m#{self}\e[0m"
  end

  def on_yellow
    "\e[0;30;43m#{self}\e[0m"
  end
end

branches = `git branch --sort=-committerdate | head -n 13 | sort`.split("\n") || ([] of String)
commit_messages = branches.map { |b| `git show -s --format=%B #{b} | cat` }
current_branch = `git branch`.split("\n").select { |s| s.match(/\*/) }.first[2..-1]

current_position = branches.index { |s| s.match(/#{current_branch}/) } || 0
branches.map! { |o| o.size > 0 ? o[2..-1] : o }
begin_position = current_position
branch_count = branches.size

def draw(current_position, branches, begin_position, commit_messages)
  system("clear")
  output = ""
  branches.each_with_index do |tail, index|
    output = output + (
      if begin_position == current_position && (index == current_position)
        ("* " + tail).blue + "\n"
      elsif begin_position != current_position && (index == current_position)
        ("* " + tail).green + "\n"
      else
        "  " + tail + "\n"
      end
    )
  end
  puts output +
       "\n" +
       "git branch " +
       branches[begin_position].blue +
       " → ".red +
       branches[current_position].green +
       "\n" +
       commit_messages[current_position].on_yellow
end

draw(current_position, branches, begin_position, commit_messages)

loop do
  case STDIN.raw(&.read_char)
  when 'j'  then current_position < branch_count - 1 ? (current_position += 1) : 0
  when 'k'  then current_position > 0 ? (current_position -= 1) : 0
  when '\r' then break
  else
    exit(1)
  end
  draw(current_position, branches, begin_position, commit_messages)
end

puts `git checkout #{branches[current_position]}`
    
