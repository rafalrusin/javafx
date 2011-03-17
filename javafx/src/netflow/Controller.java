package netflow;

import java.util.Map;
import java.util.WeakHashMap;

public class Controller {
    public Model model;
    public Map<MNode, Object> renderedItems = new WeakHashMap<MNode, Object>();

    public void createNode(double x, double y) {
//
//        var shape1:MyShape = MyShape {
//                        node: InnerNode {}
//                        position: Point2D { x: e.x y: e.y }
//                        controller: this
//                    }
//        insert shape1 into items;
//        shape1.node.nameBox.text = "node-{items.size()}";
    }

    public void deleteNode(MNode n) {
//        var l:MyNode[] = items;
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

//    public function connectNode(n:MyNode):Void {
//        if (selected != null) {
//            var a:MyShape = selected as MyShape;
//            var b:MyShape = n as MyShape;
//
//            //Delete connection if already exists
//            for (i:MyNode in items) {
//                if (i instanceof MyLine) {
//                    var j:MyLine = i as MyLine;
//                    if (j.a == a and j.b == b or j.a == b and j.b == a) {
//                        delete i from items;
//                        update();
//                        return;
//                    }
//                }
//            }
//
//            //Add new connection
//            var l:MyLine = MyLine {
//                a: a
//                b: b
//                node: InnerConnection {}
//            }
//            insert l into items;
//            update();
//        }
//    }

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

}
