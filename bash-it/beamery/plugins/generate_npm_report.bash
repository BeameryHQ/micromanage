#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.bash_it/plugins/available/beamery/pluginsInterface.bash"

# generate_npm_report
# Generate NPM report using the npm-check module to inspect the state of our npm modules
# The function will check if npm-check is installed and install it otherwise
# The report will be generated in the root directory and will be called npm-report.txt

generate_npm_report() {

	check_npm_report() {
    	if [[ -f "npm-report.txt" ]]; then
    		read -p "We have detected that an npm-report already exists. Would you like to clear that out before ? [Y/N] " -n 1;
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				rm -rf "npm-report.txt"
				echo ""
			fi;
    	fi;
	}

	if [[ $@ == *'-s'* ]]; then
		echo "This function is not designed to work in single folder mode .. please revert to good old fashioned commands"
	else
	    if command_exists npm-check ; then
			check_npm_report
	        execute -n 'echo "Checking NPM modules in package.json"; echo [REPOSITORY] `basename $PWD` >> ../npm-report.txt;  npm-check >> ../npm-report.txt'
	    else
	        printf 'npm-check module was not found. Installing now:';
	        npm install -g npm-check
	        check_npm_report
	        execute -n 'echo "Checking NPM modules in package.json"; echo [REPOSITORY] `basename $PWD` >> ../npm-report.txt;  npm-check >> ../npm-report.txt'
	    fi
	fi;
}
