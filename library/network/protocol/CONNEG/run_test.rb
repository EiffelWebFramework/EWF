#!/usr/bin/env ruby
# Niklaus Giger, 15.01.2011
# Small ruby-script run all tests using ec (the Eiffel compiler) 
# we assumen that ec outputs everything in english!

# For the command line options look at
# http://docs.eiffel.com/book/eiffelstudio/eiffelstudio-command-line-options
# we use often the -batch open.
#
# TODO: Fix problems when compiling takes too long and/or there
#       are ec process lingering around from a previous failed build

require 'tempfile'
require 'fileutils'

# Override system command.
# run command. if not successful, complain and exit with error
def system(cmd)
  puts cmd
  res = Kernel.system(cmd)
  if !res 
    puts "Failed running: #{cmd}"
    exit 2
  end
end


def runTestForProject(where)
  if !File.directory?(where)
    puts "Directory #{where} does not exist"
    exit 2
  end

  # create a temporary file with input for the 
  # interactive mode of ec
  commands2run=<<EOF
T
E
q
EOF
  file = Tempfile.new('commands2run')
  file.puts commands2run
  file.close

  Dir.chdir(where)
  # First we have to remove old compilation
  FileUtils.rm_rf("EIFGENs")
  
  # compile the library
  cmd = "ec -config library/emime-safe.ecf -target emime -batch -c_compile" 
  res = system(cmd)

  # compile the test
  cmd = "ec -config test/test-safe.ecf -target test -batch -c_compile" 
  res = system(cmd)

   
  logFile = "#{__FILE__}.log"
  sleep 1
  cmd = "ec -config test/test-safe.ecf -target test -batch -loop 1>#{logFile} 2>#{__FILE__}.auto_test_output <#{file.path}"
  res = system(cmd)
  m= nil
  IO.readlines(logFile).each{
    |line|
	m = /(\d+) tests total \((\d+) executed, (\d+) failing, (\d+) unresolved/.match(line)
	break if m 
  }

  puts
  if m[3].to_i == 0 and m[4].to_i == 0  then
    puts "#{m[1]} tests completed successfully"
  else
    puts "Failures while running #{m[1]} failed. #{m[2]} executed  #{m[3]} failures #{m[4]} unresolved"
    exit 2
  end
end

runTestForProject(Dir.pwd)

