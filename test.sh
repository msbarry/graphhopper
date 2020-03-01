#!/usr/bin/env bash
# 2D
# total 124M
# -rw-r--r--  1 mike staff  38M Feb 29 17:43 geometry

# 0 ele/0 long
# total 146M
# -rw-r--r--  1 mike staff  55M Feb 29 17:45 geometry

# 0 ele/30 long
# total 159M
# -rw-r--r--  1 mike staff  68M Feb 29 17:46 geometry

# 1 ele/0 long
# total 153M
# -rw-r--r--  1 mike staff  62M Feb 29 17:48 geometry

# 1 ele/30 long
# -rw-r--r--  1 mike staff  94M Feb 29 17:39 geometry

# 5 ele/30 long
# total 165M
# -rw-r--r--  1 mike staff  74M Feb 29 17:51 geometry



# echo ""
# echo "2D"
# rm -rf north-america_us_pennsylvania-gh
# cp config.yml config2.yml
# time java -Ddw.graphhopper.datareader.file=north-america_us_pennsylvania.pbf \
#   -Ddw.graphhopper.graph.location=./north-america_us_pennsylvania-gh \
#   -jar web/target/graphhopper-web-1.0-SNAPSHOT.jar import config2.yml | grep pass1
# ls -alh north-america_us_pennsylvania-gh/geometry

for elevationMaxDist in 1.5; do
	for samplingDist in 0 15 30 45 60 100 500; do
		echo ""
	  echo "elevationMaxDist=$elevationMaxDist samplingDist=$samplingDist"
		rm -rf north-america_us_pennsylvania-gh
		cp config.yml config2.yml
		echo "  graph.elevation.provider: skadi" >> config2.yml
		echo "  graph.elevation.long_edge_sampling_distance: $samplingDist" >> config2.yml
		echo "  graph.elevation.elevation_max_distance: $elevationMaxDist" >> config2.yml
		echo "  graph.elevation.interpolate: true" >> config2.yml
		time java -Ddw.graphhopper.datareader.file=north-america_us_pennsylvania.pbf \
		  -Ddw.graphhopper.graph.location=./north-america_us_pennsylvania-gh \
		  -jar web/target/graphhopper-web-1.0-SNAPSHOT.jar import config2.yml | grep pass1
		ls -alh north-america_us_pennsylvania-gh/geometry
	done 
done 

for elevationMaxDist in 0 1 1.5 2 3 4 5 10 50; do
	for samplingDist in 15; do
		echo ""
	  echo "elevationMaxDist=$elevationMaxDist samplingDist=$samplingDist"
		rm -rf north-america_us_pennsylvania-gh
		cp config.yml config2.yml
		echo "  graph.elevation.provider: skadi" >> config2.yml
		echo "  graph.elevation.long_edge_sampling_distance: $samplingDist" >> config2.yml
		echo "  graph.elevation.elevation_max_distance: $elevationMaxDist" >> config2.yml
		echo "  graph.elevation.interpolate: true" >> config2.yml
		time java -Ddw.graphhopper.datareader.file=north-america_us_pennsylvania.pbf \
		  -Ddw.graphhopper.graph.location=./north-america_us_pennsylvania-gh \
		  -jar web/target/graphhopper-web-1.0-SNAPSHOT.jar import config2.yml | grep pass1
		ls -alh north-america_us_pennsylvania-gh/geometry
	done 
done 
