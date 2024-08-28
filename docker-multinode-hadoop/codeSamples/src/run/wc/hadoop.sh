#!/usr/bin/env bash

hadoop fs -rm -r /demo

hadoop fs -mkdir -p /demo/input

hadoop fs -copyFromLocal /tmp/run_volume/words.txt /demo/input

hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar -input /demo/input -output /demo/output -mapper /tmp/run_volume/mapper.py -reducer /tmp/run_volume/reducer.py

hadoop fs -cat /demo/output/part-00000


