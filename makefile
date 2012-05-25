REPORT_FILE=coverage.html
ifdef USERPROFILE
	RM=rm -rf
	BROWSE=start
else
	RM=rm -rf
	BROWSE=open
endif

test-all:
	mocha --compilers coffee:coffee-script

compile:
	coffee -o lib-js -c lib

coverage: compile
	jscoverage --no-highlight lib-js lib-cov
	$(SETENV)
	mocha --compilers coffee:coffee-script -R html-cov > $(REPORT_FILE)
	$(RM) lib-cov
	$(BROWSE) $(REPORT_FILE)

clean:
	$(RM) lib-cov
	$(RM) lib-js

.PHONY: test-all

