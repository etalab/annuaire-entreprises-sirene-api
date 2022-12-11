.PHONY: loadtest
loadtest:
	k6 run loadtest/search.js --summary-export=loadtest/results/search/`date +%Y%m%d`.json
