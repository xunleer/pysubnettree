# Makefile not needed to build module. Use "python setup.py install" instead.
#
# This Makefile generates the SWIG wrappers and the documentation.

DISTFILES=COPYING Makefile README SubnetTree.cc SubnetTree.h \
	SubnetTree.i SubnetTree.py SubnetTree_wrap.cc patricia.c patricia.h setup.py test.py

CLEAN=build SubnetTree_wrap.cc SubnetTree.py README.html *.pyc 

VERSION=`test -e VERSION && cat VERSION || cat ../VERSION`
BUILD=build
TGZ=pysubnettree-$(VERSION)

all: SubnetTree_wrap.cpp

SubnetTree_wrap.cpp SubnetTree.py: SubnetTree.i SubnetTree.h
	swig -c++ -python -o SubnetTree_wrap.cc SubnetTree.i

clean:
	rm -rf $(CLEAN)

.PHONY: dist
dist:
	@python setup.py sdist
	@printf "Package: "; echo dist/*.tar.gz

distclean:
	rm -rf pysubnettree.egg-info
	rm -rf dist
	rm -rf build

.PHONY: upload
upload: twine-check dist
	twine upload -u zeek dist/pysubnettree-$(VERSION).tar.gz

.PHONY: twine-check
twine-check:
	@type twine > /dev/null 2>&1 || \
		{ \
		echo "Uploading to PyPi requires 'twine' and it's not found in PATH."; \
		echo "Install it and/or make sure it is in PATH."; \
		echo "E.g. you could use the following command to install it:"; \
		echo "\tpip install twine"; \
		echo ; \
		exit 1; \
		}

.PHONY : test
test:
	@make -C testing
