.PHONY : clean superclean build install

default: clean build

clean:
	swift package clean

superclean: clean
	rm -rf .build

build:
	swift build

install: clean
	swift build -c release
	mv .build/release/reactant /usr/local/bin/reactant
