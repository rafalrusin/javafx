package netflow.model;

import java.util.Map;
import java.util.WeakHashMap;

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
        model.nodes.remove(n);
//        //Delete connections
//        for (i:MyNode in l) {
//            if (i instanceof MyLine) {
//                var v:MyLine = i as MyLine;
//                if (v.a == n or v.b == n) {
//                    delete i from items;
//                }
//            }
//        }
//
//        //Delete node
//        delete n from items;
//        update();
    }

//    public function selectNode(n:MyNode):Void {
//        selected = n;
//        for (i:MyNode in items) {
//            if (i instanceof MyShape) {
//                var s:MyShape = i as MyShape;
//                if (i == n) {
//                    s.node.selectionColor = Color.RED;
//                } else {
//                    s.node.selectionColor = Color.LIGHTBLUE;
//                }
//            }
//        }
//    }

//    public function calculateFlow():Void {
//        try {
//            var edgeMap:Map = new HashMap();
//            var g:Fulkerson = new Fulkerson();
//
//            for (i:MyNode in items) {
//                if (i instanceof MyLine) {
//                    var l:MyLine = i as MyLine;
//                    edgeMap.put(l, g.addEdge(l.a, l.b, Double.parseDouble(l.node.capacityBox.text)));
//                }
//            }
//
//            var source:Object = new Object();
//            var sink:Object = new Object();
//
//            for (i:MyNode in items) {
//                if (i instanceof MyShape) {
//                    var s:MyShape = i as MyShape;
//                    if (s.node.typeBox.selectedIndex == 1) {
//                        edgeMap.put(s, g.addEdge(source, s, Double.parseDouble(s.node.capacityTextBox.text)));
//                    }
//                    if (s.node.typeBox.selectedIndex == 2) {
//                        edgeMap.put(s, g.addEdge(s, sink, Double.parseDouble(s.node.capacityTextBox.text)));
//                    }
//                }
//            }
//
//            maxFlowLabel.text = "{g.maxFlow(source,sink)}";
//
//            for (i:MyNode in items) {
//                if (i instanceof MyLine) {
//                    var l:MyLine = i as MyLine;
//                    l.node.flow = g.flow.get(edgeMap.get(l));
//                }
//            }
//
//            for (i:MyNode in items) {
//                if (i instanceof MyShape) {
//                    var s:MyShape = i as MyShape;
//                    if (edgeMap.containsKey(s)) {
//                        s.node.flow = g.flow.get(edgeMap.get(s));
//                    }
//                }
//            }
//        } catch (t:Throwable) {
//            JOptionPane.showMessageDialog(null, "Error {t.getMessage()}");
//        }
//    }


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
        l.capacity = 0;
        l.flow = 10;
        model.nodes.add(l);
    }
}
