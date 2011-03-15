package netflow;
import javafx.scene.Node;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import java.lang.Void;
import netflow.MyNode;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseEvent;

public class MyController extends Container {
    public var items:MyNode[];

    public var selected:MyNode = null;

    public function update():Void {
//        for (i:MyNode in items) {
//            i.update();
//        }
        content = items;
        requestLayout();
    }

    public function createNode(e:MouseEvent):Void {
        var shape1:MyShape = MyShape {
                        node: InnerNode {}
                        position: Point2D { x: e.x y: e.y }
                        controller: this
                    }
        insert shape1 into items;
        shape1.node.nameBox.text = "node-{items.size()}";
    }

    public function deleteNode(n:MyNode):Void {
        var l:MyNode[] = items;
        //Delete connections
        for (i:MyNode in l) {
            if (i instanceof MyLine) {
                var v:MyLine = i as MyLine;
                if (v.a == n or v.b == n) {
                    delete i from items;
                }
            }
        }

        //Delete node
        delete n from items;
        update();
    }

    public function connectNode(n:MyNode):Void {
        if (selected != null) {
            var a:MyShape = selected as MyShape;
            var b:MyShape = n as MyShape;

            //Delete connection if already exists
            for (i:MyNode in items) {
                if (i instanceof MyLine) {
                    var j:MyLine = i as MyLine;
                    if (j.a == a and j.b == b or j.a == b and j.b == a) {
                        delete i from items;
                        update();
                        return;
                    }
                }
            }

            //Add new connection
            var l:MyLine = MyLine { a: a b: b node: Tools.genConnection("0", "10") }
            insert l into items;
            update();
        }
    }

    public function selectNode(n:MyNode):Void {
        selected = n;
        for (i:MyNode in items) {
            if (i instanceof MyShape) {
                var s:MyShape = i as MyShape;
                if (i == n) {
                    s.node.selectionColor = Color.RED;
                } else {
                    s.node.selectionColor = Color.LIGHTBLUE;
                }
            }
        }
    }

    override public function doLayout():Void {
        for (i:Node in getManaged(content)) {
            if (i instanceof MyShape) {
                var k:MyShape = i as MyShape;
                layoutNode(i,0,0,getNodePrefWidth(i),getNodePrefHeight(i));
                positionNode(i, -getNodePrefWidth(i)/2 + k.position.x, -getNodePrefHeight(i)/2 + k.position.y);
            }
        }

        for (i:MyNode in items) {
            if (i instanceof MyLine) {
                var l:MyLine = i as MyLine;
                l.rebuild();
            }
        }
    }
}