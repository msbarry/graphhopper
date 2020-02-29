package com.graphhopper.util;

import com.graphhopper.reader.dem.ElevationProvider;

public class EdgeSampling {
    private EdgeSampling() {}

    public static PointList sample(PointList input, Double maxDistance, DistanceCalc distCalc, ElevationProvider elevation) {
        // assume this will add 10%
        PointList output = new PointList((input.getSize() * 11) / 10, input.is3D());
        if (input.isEmpty()) return output;
        int nodes = input.getSize();
        double lastLat = input.getLat(0), lastLon = input.getLon(0), thisLat, thisLon, thisEle;
        for (int i = 0; i < nodes; i++) {
            thisLat = input.getLat(i);
            thisLon = input.getLon(i);
            thisEle = input.getEle(i);
            if (i > 0 && !distCalc.isCrossBoundary(lastLon, thisLon)) {
                double segments = Math.round(distCalc.calcDist(lastLat, lastLon, thisLat, thisLon) / maxDistance);
                for (double segment = 1; segment < segments; segment++) {
                    double ratio = segment / segments;
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
