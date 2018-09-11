.PHONY: ps ide

ps:
	psc-package sources | xargs purs compile '/home/nicholaw/purerl/purescript-erl-cowboy/src/**/*.purs' 'src/**/*.purs' 


ide:
	psc-package sources | xargs purs compile '/home/nicholaw/purerl/purescript-erl-cowboy/src/**/*.purs' 'src/**/*.purs' --json-errors
