.PHONY: all install uninstall

PREFIX ?= /usr

all:
	mix deps.get
	mix escript.build
install:
	install -D -m 0755 bin/typokiller $(DESTDIR)$(PREFIX)/bin/typokiller

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/typokiller
