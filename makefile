# Feel free to change these #
#------------------------------------#

# .class containing the main function
MAIN		:=	Main

# Compiler to use
JC			:=	javac

# Directory in which all .java files lie
SDIR		:=	src

#	Directory in which all .class files will be put
BIN			:=	bin

# Name of the directory of the project. This will be the name of the .jar file, but is safe to change.
DIR			:=	$(notdir $(shell pwd))

# Default profile, ran using `make`
.DEFAULT_GOAL := run

# Don't change these #
#------------------------------------#

# A list of profiles that should always be run, even if they are seen as "up to date"
.PHONY: run clean help

# A list of all source-files
SRCS	= $(wildcard $(SDIR)/*.java)

# Dependency profiles
#------------------------------------#

#Create a bin directory if it doesn't exist already
$(BIN):
	mkdir bin

#Compile the program, as in, all .class files in $(SDIR), and put the .class files in $(BIN)
compile: $(SRCS) | $(BIN) $(SDIR)
	$(JC) -d $(BIN) $(SRCS)

#define a newline character for formatting
define newline


endef

#Short message explaining what this makefile does. Runs when the source folder doesn't exist, as that implies very incorrect useage.
$(SDIR):
	$(error $(newline) The way this makefile works is that it looks for files in the $(SDIR) directory, and compiles all of them into the $(BIN) directory.$(newline)\
	This results in two mirrored folders, $(SDIR) and $(BIN), one of which contains all .java files, and one of which contains all .class files. $(newline)\
	This file should be ran from the directory containing $(SDIR), and you need a class called $(MAIN) containing your main() function. $(newline)\
	Run 'make help' for some information)

# Profiles for running
#------------------------------------#

#Sets up the source directory, if you are extra lazy
setup:
	-mkdir $(SDIR)

#Runs the program
run: compile
	java -cp $(BIN): $(MAIN)

#Makes a .jar file, which is a portable executable
jar: $(SRCS) compile
	echo $(DIR)
	jar cfe $(DIR).jar $(MAIN) -C $(BIN) .

#Removes $(BIN) for the sake of cleaning up
clean:
	rm -r $(BIN)

#Prints a help message
help:
	@echo A makefile for generic java programs
	@echo 
	@echo "Usage:"
	@echo "	make"
	@echo "	make run		compile all files in $(SDIR)/ and run $(MAIN).class"
	@echo
	@echo "	make jar		compile all files in $(SDIR)/ into a jar file $(DIR).jar"
	@echo
	@echo "	make clean		removes $(BIN)/, created by compiling"
	@echo
	@echo "	make help		print this message"
	@echo
	@echo "	make compile		compile all files in $(SDIR)/"
	@echo
	@echo "	make $(SDIR)		display a message explaining what this makefile does"
	@echo
	@echo "	make $(BIN)		create the folder $(BIN)"
	@echo
	@echo "	make setup		create the folder $(SDIR)"
	@echo
	@echo "To turn on verbose output, run 'make VERBOSE=1'"
	@echo 
	@echo "Configuration Options:"
	@echo "	The source directory, which is by default $(SDIR)"
	@echo 
	@echo "	The bin directory, which is by default $(BIN)"
	@echo 
	@echo "	The main class, which is by default $(MAIN)"
	@echo 
	@echo "	The name of the jar file, which is by default the name of the directory the make file is being ran from"
	@echo "	i.e $(DIR)"
	@echo 
	@echo "WARNING: Currently does not support compiling with resources"

#Prevents echoing of commands, unless VERBOSE is defined
$(VERBOSE).SILENT: all
