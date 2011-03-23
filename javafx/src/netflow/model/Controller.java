package netflow.model;

import java.net.URL;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.WeakHashMap;
import javax.swing.JOptionPane;
import netflow.Fulkerson;

public class Controller {
    public Model model;
    public Map<MNode, Object> renderedItems = new WeakHashMap<MNode, Object>();

    public void createNode(double x, double y) {
        MShape shape = new MShape();
        shape.name = "node-" + (model.nodes.size()+1);
        shape.x = x;
        shape.y = y;
        model.nodes.add(shape);
    }

    public void deleteNode(MNode n) {
        //Delete connections
        Set<MNode> toDelete = new HashSet<MNode>();
        for (MNode i : model.nodes) {
            if (i instanceof MLine) {
                MLine l = (MLine) i;
                if (l.a == n || l.b == n) {
                    toDelete.add(l);
                }
            }
        }
        model.nodes.removeAll(toDelete);

        //Delete node
        model.nodes.remove(n);
    }

    public double calculateFlow() {
        Map edgeMap = new HashMap();
        Fulkerson g = new Fulkerson();

        for (MNode i : model.nodes) {
            if (i instanceof MLine) {
                MLine l = (MLine) i;
                System.out.println("Line "+l.a.name + " -> " + l.b.name + " " + l.capacity);
                edgeMap.put(l, g.addEdge(l.a, l.b, l.capacity, l.capacity));
            }
        }

        Object source = new Object();
        Object sink = new Object();

        for (MNode i : model.nodes) {
            if (i instanceof MShape) {
                MShape s = (MShape) i;
                System.out.println("Shape "+s.name + " type " + s.type + " capacity " + s.capacity);
                if (s.type == MShape.ShapeType.SOURCE) {
                    edgeMap.put(s, g.addEdge(source, s, s.capacity, 0));
                }
                if (s.type == MShape.ShapeType.SINK) {
                    edgeMap.put(s, g.addEdge(s, sink, s.capacity, 0));
                }
            } else {
            }
        }

        double maxFlow = g.maxFlow(source,sink);

        for (MNode i : model.nodes) {
            if (i instanceof MLine) {
                MLine l = (MLine) i;
                l.flow = g.flow.get(edgeMap.get(l));
            }
        }

        for (MNode i : model.nodes) {
            if (i instanceof MShape) {
                MShape s = (MShape) i;
                if (edgeMap.containsKey(s)) {
                    s.flow = g.flow.get(edgeMap.get(s));
                }
            }
        }
        return maxFlow;
    }

    public void connectNodes(MShape a, MShape b) {
        //Delete connection if already exists
        for (MNode i : model.nodes) {
            if (i instanceof MLine) {
                MLine j = (MLine) i;
                if (j.a == a && j.b == b || j.a == b && j.b == a) {
                    model.nodes.remove(i);
                    return;
                }
            }
        }

        //Add new connection
        MLine l = new MLine();
        l.a = a;
        l.b = b;
        model.nodes.add(l);
    }

    public void openURL(String url) {
        try {
           URL u = new URL(url);
           Model m = (Model) Model.getXStream().fromXML(u.openStream());
           model = m;
        } catch (Throwable t) {
            t.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error " + t.getMessage());
        }
    }
}
