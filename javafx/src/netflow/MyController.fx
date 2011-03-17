package netflow;
import javafx.scene.Node;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import java.lang.Void;
import netflow.MyNode;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseEvent;
import javafx.scene.control.Label;
import java.lang.Throwable;
import javax.swing.JOptionPane;
import java.util.HashMap;
import java.util.Map;
import java.util.WeakHashMap;

public class MyController extends Container {
    public var maxFlowLabel:Label;
    public var controller:Controller = new Controller();

    public var selected:MyNode = null;

    public function render(i:MNode):MyNode {
        if (controller.renderedItems.containsKey(i)) {
            return controller.renderedItems.get(i) as MyNode;
        } else {
            var uiNode: MyNode;
            if (i instanceof MShape) {
                uiNode = MyShape {
                    model: i
                    controller: this
                }
            } else if (i instanceof MLine) {
                uiNode = MyLine {
                    model: i
                    controller: this
                }
            }

            controller.renderedItems.put(i, uiNode);
            return uiNode;
        }
    }


    public function update():Void {
        for (i:MNode in controller.model.nodes) {
            if (i instanceof MShape) {
                render(i);
            }
        }
        for (i:MNode in controller.model.nodes) {
            if (i instanceof MLine) {
                render(i);
            }
        }
        
        content = for (i:Object in controller.renderedItems.values()) {
            i as MyNode
        }

        requestLayout();
    }


    override public function doLayout():Void {
        for (i:Node in getManaged(content)) {
            if (i instanceof MyShape) {
                var k:MyShape = i as MyShape;
                layoutNode(i,0,0,getNodePrefWidth(i),getNodePrefHeight(i));
                positionNode(i, -getNodePrefWidth(i)/2 + k.position.x, -getNodePrefHeight(i)/2 + k.position.y);
            }
        }

//        for (i:MyNode in items) {
//            if (i instanceof MyLine) {
//                var l:MyLine = i as MyLine;
//                l.rebuild();
//            }
//        }
    }

    public function calculateFlow():Void {
        try {
            var edgeMap:Map = new HashMap();
            var g:Fulkerson = new Fulkerson();

            for (i:MyNode in items) {
                if (i instanceof MyLine) {
                    var l:MyLine = i as MyLine;
                    edgeMap.put(l, g.addEdge(l.a, l.b, Double.parseDouble(l.node.capacityBox.text)));
                }
            }

            var source:Object = new Object();
            var sink:Object = new Object();

            for (i:MyNode in items) {
                if (i instanceof MyShape) {
                    var s:MyShape = i as MyShape;
                    if (s.node.typeBox.selectedIndex == 1) {
                        edgeMap.put(s, g.addEdge(source, s, Double.parseDouble(s.node.capacityTextBox.text)));
                    }
                    if (s.node.typeBox.selectedIndex == 2) {
                        edgeMap.put(s, g.addEdge(s, sink, Double.parseDouble(s.node.capacityTextBox.text)));
                    }
                }
            }

            maxFlowLabel.text = "{g.maxFlow(source,sink)}";

            for (i:MyNode in items) {
                if (i instanceof MyLine) {
                    var l:MyLine = i as MyLine;
                    l.node.flow = g.flow.get(edgeMap.get(l));
                }
            }

            for (i:MyNode in items) {
                if (i instanceof MyShape) {
                    var s:MyShape = i as MyShape;
                    if (edgeMap.containsKey(s)) {
                        s.node.flow = g.flow.get(edgeMap.get(s));
                    }
                }
            }
        } catch (t:Throwable) {
            JOptionPane.showMessageDialog(null, "Error {t.getMessage()}");
        }
    }
}
