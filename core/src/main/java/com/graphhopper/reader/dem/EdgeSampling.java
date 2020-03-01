package com.graphhopper.reader.dem;

import com.graphhopper.util.DistanceCalc;
import com.graphhopper.util.PointList;

public class EdgeSampling {
    private EdgeSampling() {}

    public static PointList sample(PointList input, double maxDistance, DistanceCalc distCalc, ElevationProvider elevation) {
        PointList output = new PointList(input.getSize() * 2, input.is3D());
        if (input.isEmpty()) return output;
        int nodes = input.getSize();
        double lastLat = input.getLat(0), lastLon = input.getLon(0), thisLat, thisLon, thisEle;
        for (int i = 0; i < nodes; i++) {
            thisLat = input.getLat(i);
            thisLon = input.getLon(i);
            thisEle = input.getEle(i);
            if (i > 0 && !distCalc.isCrossBoundary(lastLon, thisLon)) {
                int segments = (int) Math.round(distCalc.calcDist(lastLat, lastLon, thisLat, thisLon) / maxDistance);
                for (int segment = 1; segment < segments; segment++) {
                    double ratio = (double) segment / segments;
                    double lat = lastLat + (thisLat - lastLat) * ratio;
                    double lon = lastLon + (thisLon - lastLon) * ratio;
                    double ele = elevation.getEle(lat, lon);
                    if (!Double.isNaN(ele)) {
                        output.add(lat, lon, ele);
                    }
                }
            }
            output.add(thisLat, thisLon, thisEle);
            lastLat = thisLat;
            lastLon = thisLon;
        }
        return output;
    }
}
