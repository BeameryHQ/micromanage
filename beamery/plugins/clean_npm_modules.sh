#!/usr/bin/env bash

# Load the main plugins "interface"
source "${HOME}/.beamery/beamery/pluginsInterface.sh"

# clean_npm_modules
# Clean unused NPM modules from each repo
# The function will check if npm-clean is installed and install it otherwise

clean_npm_modules() {

	check_npm_report() {
    	if [[ -f "npm-report.txt" ]]; then
    		read -p "We have detected that an npm-clean-report already exists. Would you like to clear that out before ? [Y/N] " -n 1;
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				rm -rf "npm-clean-report.txt"
				echo ""
			fi;
    	fi;
	}

	if [[ $@ == *'-s'* ]]; then
		echo "This function is not designed to work in single folder mode .. please revert to good old fashioned commands"
	else
	    if  command_exists npm-clean ; then
	    	check_npm_report
	    	execute -n 'echo "Cleaning NPM modules in package.json"; echo [REPOSITORY] `basename $PWD` >> ../npm-clean-report.txt;  npm-clean >> ../npm-clean-report.txt'
	    else
	        printf 'npm-check module was not found. Installing now:';
	        npm install -g npm-clean
	        check_npm_report
	        execute -n 'echo "Cleaning NPM modules in package.json"; echo [REPOSITORY] `basename $PWD` >> ../npm-clean-report.txt;  npm-clean >> ../npm-clean-report.txt'
	    fi
	fi;
}
