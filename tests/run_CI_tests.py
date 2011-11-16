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
	clobber = len(sys.argv) >= 2 and sys.argv[1] == "-clobber"
	if clobber:
		rm_dir("EIFGENs")

	# compile the restbucks
	print "# Compiling restbucks example"
	cmd = "ecb -config %s -target restbucks -batch -c_compile -project_path . " % (os.path.join ("examples", "restbucks", "restbucks-safe.ecf"))
	res = eval_cmd(cmd)

	sleep(1)

	print "# Launch check_compilations"
	if sys.platform == 'win32':
		cmd = "tests\\check_compilations.bat"
	else:
		cmd = "tests//check_compilations.sh"
	if clobber:
		cmd = "%s -clean" % (cmd)
	res_output = eval_cmd_output(cmd)

	print "# Analyze check_compilations results"
	lines = re.split ("\n", res_output)
	regexp = "^(\S+)\s+(\S+)\s+from\s+(\S+)\s+\(([^\)]+)\)\.\.\.(\S+)$"
	p = re.compile (regexp);
	failures = [];
	non_failures = [];
	for line in lines:
		p_res = p.search(line.strip(), 0)
		if p_res:
			# name, target, ecf, result
			if p_res.group(5) == "Failed":
				failures.append ({"name": p_res.group(2), "target": p_res.group(3), "ecf": p_res.group(4), "result": p_res.group(5)})
			else:
				non_failures.append ({"name": p_res.group(2), "target": p_res.group(3), "ecf": p_res.group(4), "result": p_res.group(5)})
	for non_fails in non_failures:
		print "[%s] %s : %s @ %s" % (non_fails["result"], non_fails["name"], non_fails["ecf"], non_fails["target"])
	for fails in failures:
		print "[FAILURE] %s : %s @ %s" % (fails["name"], fails["ecf"], fails["target"])
	sleep(1)
	if len(failures) > 0:
		sys.exit(2)

	print "# End..."

if __name__ == '__main__':
	runTestForProject(os.path.join (os.getcwd(), '..'))

