package netflow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Fulkerson {
    public static class Edge {
        Object source;
        Object sink;
        double capacity;
        double residual;
        Edge redge;

        public Edge(Object source, Object sink, double capacity) {
            this.source = source;
            this.sink = sink;
            this.capacity = capacity;
        }

        @Override
        public String toString() {
            return "Edge{" + "source=" + source + " sink=" + sink + " capacity=" + capacity + '}';
        }
    }

    public Map<Object, List<Edge>> adj = new HashMap<Object, List<Edge>>();
    public Map<Edge, Double> flow = new HashMap<Edge, Double>();

    private List<Edge> getAdj(Object o, List<Edge> value) {
        if (adj.containsKey(o)) {
            return adj.get(o);
        } else {
            adj.put(o, value);
            return value;
        }
    }

    private boolean findPath(Object source, Object sink, Set<Edge> path, Set<Object> visited) {
        if (visited.contains(source)){
            return false;
        }
        visited.add(source);
        if (source == sink) {
            return true;
        } else {
            for (Edge edge : adj.get(source)) {
                edge.residual = edge.capacity - flow.get(edge);
                if (edge.residual > 0 && !path.contains(edge)) {
                    path.add(edge);
                    boolean result = findPath(edge.sink, sink, path, visited);
                    if (result) {
                        return true;
                    }
                    path.remove(edge);
                }
            }
        }
        return false;
    }

    private Set<Edge> findPath(Object source, Object sink) {
        Set<Edge> path = new HashSet<Edge>();
        Set<Object> visited = new HashSet<Object>();
        if (findPath(source, sink, path, visited)) {
            return path;
        } else {
            return null;
        }
    }

    public Edge addEdge(Object u, Object v, double w, double z) {
        Edge edge  = new Edge(u,v,w);
        Edge redge = new Edge(v,u,z);
        edge.redge  = redge;
        redge.redge = edge;
        getAdj(u, new ArrayList<Edge>()).add(edge);
        getAdj(v, new ArrayList<Edge>()).add(redge);
        flow.put(edge, 0.);
        flow.put(redge, 0.);
        return edge;
    }

    public double maxFlow(Object source, Object sink) {
        Set<Edge> path = findPath(source, sink);
        while (path != null) {
            double minFlow = Double.MAX_VALUE;
            for (Edge e : path) {
                minFlow = Math.min(minFlow, e.residual);
            }
            for (Edge e : path) {
                flow.put(e, flow.get(e) + minFlow);
                flow.put(e.redge, flow.get(e.redge) - minFlow);
            }
            path = findPath(source, sink);
        }

        double maxFlow = 0;
        for (Edge edge : adj.get(source)) {
            maxFlow += flow.get(edge);
        }
        return maxFlow;
    }
}
