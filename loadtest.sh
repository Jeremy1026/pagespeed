#!/bin/sh

while getopts ":u:c:" opt; do
  case $opt in
    u) url="$OPTARG"
    ;;
    c) count="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z "$url" ] 
	then
	echo "Please include a URL (-u) to test."
	exit
fi
if [ -z "$count" ]
	then
	count="10"
fi

echo ""
printf "Load Time Testing: %s\n" "$url"

sum=0
max=0
min=100
for ((i=0; i<count; i++)); do
	result=$(curl -o /dev/null  -s -w "%{time_total}\n" "$url")

	sum=$(echo $s | awk "{print (($result+$sum))}")

	if (( $(echo "$max $result" | awk '{ print ($1 < $2)}') )); then
		max="$result"
	fi	
	if (( $(echo "$min $result" | awk '{ print ($1 > $2)}') )); then
		min="$result"
	fi
	
done

avg=$(echo $a | awk "{print (($sum/$count))}")

echo "************************"
echo "Total Test Time:   $sum"
echo "Average Load Time: $avg"
echo "Max Load Time:     $max"
echo "Min Load Time:     $min"
echo ""