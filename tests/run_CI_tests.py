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

def last_build_had_failure():
	return os.path.exists (".last_run_CI_tests_failed")

def reset_last_run_CI_tests_failed():
	fn = ".last_run_CI_tests_failed"
	if os.path.exists (fn):
		os.remove(fn)

def set_last_run_CI_tests_failed(m):
	fn = ".last_run_CI_tests_failed"
	f = open(".last_run_CI_tests_failed", 'w')
	f.write(m)
	f.close()

def report_failure(msg, a_code=2):
	print msg
	set_last_run_CI_tests_failed(msg)
	sys.exit(a_code)

# Override system command.
# run command. if not successful, complain and exit with error
def eval_cmd(cmd):
	#  print cmd
	res = subprocess.call (cmd, shell=True)
	if res != 0:
		report_failure ("Failed running: %s (returncode=%s)" % (cmd, res), 2)
	return res

def eval_cmd_output(cmd, ignore_error=False):
	#  print cmd
	p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
	if p:
		return p.communicate()[0]
	else:
		if not ignore_error:
			report_failure ("Failed running: %s" % (cmd), 2)

def rm_dir(d):
	if os.path.isdir(d):
		shutil.rmtree(d)

def runTestForProject(where):
	if not os.path.isdir(where):
		report_failure ("Directory %s does not exist" % (where), 2)

	os.chdir(where)
	# First we have to remove old compilation
	clobber = last_build_had_failure()
	keep_all = True
	for a in sys.argv:
		if a == "-clobber":
			clobber = True
		if a == "-keep":
			keep_all = True
		if a == "-forget":
			keep_all = False

#	clobber = (len(sys.argv) >= 2 and sys.argv[1] == "-clobber") or (last_build_had_failure())
	if clobber:
		reset_last_run_CI_tests_failed()
		print "## Cleaning previous tests"
		rm_dir("EIFGENs")

	# compile the restbucks
	print "# Compiling restbucks example"
	cmd = "ecb -config %s -target restbucks -batch -c_compile -project_path . " % (os.path.join ("examples", "restbucks", "restbucks-safe.ecf"))
	res = eval_cmd(cmd)

	sleep(1)

	print "# check compile_all tests"
	if not os.path.exists(os.path.join ("tests", "temp")):
		os.makedirs (os.path.join ("tests", "temp"))


	cmd = "compile_all -ecb -melt -eifgen %s -ignore %s " % (os.path.join ("tests", "temp"), os.path.join ("tests", "compile_all.ini"))
	if keep_all:
		res_output = eval_cmd_output("compile_all -l NoWhereJustToTestUsage -keep", True)
		if res_output.find("Unreconized switch '-keep'") == -1:
			cmd = "%s -keep passed" % (cmd) # forget about failed one .. we'll try again next time

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
		report_failure ("Failure(s) occurred", 2)

	print "# End..."

if __name__ == '__main__':
	runTestForProject(os.path.join (os.getcwd(), '..'))

