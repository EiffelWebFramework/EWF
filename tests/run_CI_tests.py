#!/usr/local/bin/python
# Small python-script run all tests using ec (the Eiffel compiler) 
# we assume that ec outputs everything in english!
# 
# Code ported from a ruby script by Niklaus Giger

# For the command line options look at
# http://docs.eiffel.com/book/eiffelstudio/eiffelstudio-command-line-options
# we use often the -batch open.
#
# TODO: Fix problems when compiling takes too long and/or there
#       are ec process lingering around from a previous failed build

import os;
import sys;
import tempfile;
import shutil;
import re;
import subprocess;
from time import sleep;

# Override system command.
# run command. if not successful, complain and exit with error
def eval_cmd(cmd):
#  print cmd
  res = subprocess.call (cmd, shell=True)
  if res < 0:
    print "Failed running: %s" % (cmd)
    sys.exit(2)
  return res

def eval_cmd_output(cmd):
#  print cmd
  p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  if p:
    return p.communicate()[0]
  else:
    print "Failed running: %s" % (cmd)
    sys.exit(2)

def rm_dir(d):
  if os.path.isdir(d):
	shutil.rmtree(d)


def runTestForProject(where):
  if not os.path.isdir(where):
    print "Directory %s does not exist" % (where)
    sys.exit(2)

  os.chdir(where)
  # First we have to remove old compilation
  rm_dir("EIFGENs")
  
  # compile the library
  cmd = "ecb -config %s -target restbucks -batch -c_compile" % (os.path.join ("examples", "restbucks", "restbucks-safe.ecf"))
  res = eval_cmd(cmd)

  sleep(1)

if __name__ == '__main__':
	runTestForProject(os.path.join (os.getcwd(), '..'))

