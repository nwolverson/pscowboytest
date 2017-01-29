PREFIX:=../
DEST:=$(PREFIX)$(PROJECT)

REBAR=rebar3
REL=_build/default/rel/rel/bin/rel

.PHONY: all edoc test clean build_plt dialyzer app

all:
	make -C ps
	rm -f src/ps/*
	cp ps/output/*/*.erl src/ps/
	@$(REBAR) compile

stop:
	$(REL) stop

start:
	$(REL) start

edoc: all
	@$(REBAR) doc

test:
	@rm -rf .eunit
	@mkdir -p .eunit
	@$(REBAR) eunit

clean:
	@$(REBAR) clean
	rm -f src/ps/*
	rm -rf ps/output/*
