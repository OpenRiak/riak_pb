.PHONY: compile rel cover test dialyzer
REBAR=./rebar3

compile:
	$(REBAR) compile

clean:
	rm -rf include/*_pb.hrl
	rm -rf src/*_pb.erl
	$(REBAR) clean

cover: test
	$(REBAR) cover

test: compile
	$(REBAR) eunit

dialyzer:
	$(REBAR) dialyzer

xref:
	$(REBAR) xref

check: test dialyzer xref
