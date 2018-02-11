Interactive Git Branch
----------------------

with colors (AND SOUNDS!)

usage `./gb`

`q` to quit
`j` up
`k` down
`enter` switch to branch


# A small Ruby program rewritten in Crystal

The crystal value propositions

1. Speed - faster than ruby (closer to c-interop )
2. > 90% Similar syntax to ruby - Where it matters, defining functions, blocks, calling methods, defining classes, modules How you structure your program in the large is very similar to ruby 
3. Type system suprisingly helpful (and is kind of a static type checker for ruby)

  Language	CPU 	Memory 	Threads
  ruby    	0.75	21.1 MB	2      
  crystal 	0.01	<1KB   	8      



- j to go up
- k to go down
- enter to switch to that branch and quit the program
- any other key to quit





What does the program do?

Switch git branches

launch the program, and then use vim keybindings



1. run commands to load the output of git shell commands into data structures
2. figure out the initial paint
3. listen for keys
   - j to go up
   - k to go down
   - enter to switch to that branch and quit the program
   - any other key to quit

sh

Split Lines

    branches = `git branch  --sort=-committerdate | head -n 13 | sort`.split("\n")

backticks as a way to launch shell commands

    branches = `git branch --sort=-committerdate | head -n 13 | sort`.split("\n") || [""]










