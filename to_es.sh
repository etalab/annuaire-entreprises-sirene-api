split -l 50000 test.json test/

for f in ./test/*; do sed 's/\\\\/\\/g' $f > ./test2/"${f##*/}"; done;

ls test2/ | parallel -j 36 'jq -c -r "." test2/{} | while read line; do echo '{\\\"index\\\":\\{\\}}'; echo $line; done > test2/{}.json'

for f in ./test2/*.json; do curl -s -H "Content-Type: application/x-ndjson" --user elastic:etalab123! -XPOST localhost:9200/my-index/docs/_bulk --data-binary "@$f" > /dev/null; done;
