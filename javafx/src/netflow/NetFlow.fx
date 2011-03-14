package netflow;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.Node;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseEvent;
import javafx.scene.shape.Path;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.LineTo;
import javafx.util.Math;
import javafx.scene.transform.Affine;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.geometry.Insets;
import javafx.scene.layout.HBox;
import javafx.geometry.VPos;
import javafx.scene.layout.Container;
import javafx.scene.input.MouseButton;

abstract class MyNode extends Container {
//    abstract function update():Void;

}

class MyController extends Container {
    public var items:MyNode[];

    public var selected:MyNode = null;

    public function update():Void {
//        for (i:MyNode in items) {
//            i.update();
//        }
        content = items;
        requestLayout();
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
            var l:MyLine = MyLine { a: a b: b node: genConnection("0", "10") }
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
        for (i:Node in getManaged(content)) {
            if (i instanceof MyLine) {
                var l:MyLine = i as MyLine;
                l.rebuild();
            }
        }
    }
}

function pointsLenSqr(a:Point2D,b:Point2D):Float {
    return (a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y);
}

function middle(a:Point2D,b:Point2D):Point2D {
    return Point2D {
        x: (a.x+b.x)/2
        y: (a.y+b.y)/2
    }
}

class MyShape extends MyNode {
    public var controller:MyController;
    public var node:InnerNode;
    public var position:Point2D;

//    public var s:Node;

//    public function updatePosition():Void {
//        translateX = position.x;
//        translateY = position.y;
//    }

    var dragBase:Point2D;

    public override var onMouseDragged = function(e:MouseEvent):Void {
        position = Point2D {
            x: dragBase.x + e.dragX
            y: dragBase.y + e.dragY
        }
        controller.update();
    }

    public override var onMousePressed = function(e:MouseEvent):Void {
        dragBase = position;
        if (e.button == MouseButton.PRIMARY) {
            controller.selectNode(this);
        }
        if (e.button == MouseButton.SECONDARY) {
            if (controller.selected == this) {
                controller.deleteNode(this);
            } else {
                controller.connectNode(this);
            }
        }
    }

    public function findBoundaryPoint(a:Point2D,b:Point2D):Point2D {
        // a is outside, b is inside
        var m:Point2D = middle(a,b);
        if (pointsLenSqr(a, b) < 1.) {
            return m;
        } else {
            var n:Point2D = Point2D {
                x: m.x - position.x + width/2
                y: m.y - position.y + height/2
            }

            if (contains(n)) {
                return findBoundaryPoint(a,m);
            } else {
                return findBoundaryPoint(m,b);
            }
        }
    }

    init {
        blocksMouse = true;
//        translateX = -node.boundsInLocal.width/2;
//        translateY = -node.boundsInLocal.height/2;
//        println("{translateX} {translateY}");
//        updatePosition();
        content = [
            node
        ]
    }
}

class MyLine extends MyNode {
    public var node:Node;
    
//    override function update () : Void {
//        rebuild();
//    }

    public var a:MyShape;
    public var b:MyShape;

    public function rebuild():Void {
        var u:Point2D = a.findBoundaryPoint(b.position, a.position);
        var v:Point2D = b.findBoundaryPoint(a.position, b.position);

        var l:Float = Math.sqrt(pointsLenSqr(u, v));


        var path =             Path {
                transforms: [
                    Affine {
                        mxx: (v.x-u.x)/l
                        mxy: (v.y-u.y)/l
                        myx: (v.y-u.y)/l
                        myy: -(v.x-u.x)/l
                        tx: u.x
                        ty: u.y
                    }
                ]
            elements: [
                MoveTo {
                    x: 0
                    y: 0
                }
                LineTo {
                    x: l
                    y: 0
                }
                LineTo {
                    x: l-10
                    y: 5
                }
                MoveTo {
                    x: l
                    y: 0
                }
                LineTo {
                    x: l-10
                    y: -5
                }

                MoveTo {
                    x: 0
                    y: 0
                }
                LineTo {
                    x: 10
                    y: -5
                }

                MoveTo {
                    x: 0
                    y: 0
                }
                LineTo {
                    x: 10
                    y: 5
                }
                ]
            }

        node.layoutX = path.boundsInParent.width/2 + path.boundsInParent.minX;
        node.layoutY = path.boundsInParent.height/2 + path.boundsInParent.minY;
        println("conn layout {node.layoutX} {node.layoutY} {path.boundsInLocal}");

        content = [
            path,
            node
        ]
    }

    init {
        rebuild();
    }
}

var controller: MyController = MyController {}

class InnerNode extends Container {
    public var type: String;
    public var name: String;

    public var selectionColor: Color = Color.LIGHTBLUE;

    var rect:Rectangle=Rectangle {
        fill: bind selectionColor
        stroke: Color.BLACK
        strokeWidth: 0.5
        arcHeight: 10
        arcWidth: 10
    }

    override function doLayout():Void {
        var m:Node[] = getManaged(content);
        layoutNode(m[1],0,0,getNodePrefWidth(m[1]),getNodePrefHeight(m[1]));
        rect.width=getNodePrefWidth(m[1]);
        rect.height=getNodePrefHeight(m[1]);
    }

    init {
        var l=5;
        var b=VBox {
            padding: Insets { bottom: l top: l left: l right: l }
            content: [
                Label { text: type }
                TextBox { text: name }
            ]
        }

        content = [
            rect,
            b
        ]
    }
}

function genConnection(flow: String, maxFlow: String):Node {
    HBox {
        content: [
            Label {
                layoutInfo: LayoutInfo {
                    vpos: VPos.CENTER
                }

                text: "{flow} / "
            }
            TextBox { text: maxFlow }
            ]
    }
}


var shape1:MyShape = MyShape {
                node: InnerNode { type: "Source" name: "name" }
                position: Point2D { x: 50 y: 300 }
                controller: controller
            }
var shape2:MyShape = MyShape {
                node: InnerNode { type: "Source" name: "name" }
                position: Point2D { x: 750 y: 100 }
                controller: controller
            }
var shape3:MyShape = MyShape {
                node: InnerNode { type: "Source" name: "name" }
                position: Point2D { x: 750 y: 500 }
                controller: controller
            }

controller.items = [
    shape1,
    shape2,
    shape3,
    MyLine { a: shape1 b: shape2 node: genConnection("0", "10") }
    MyLine { a: shape2 b: shape3 node: genConnection("0", "10") }
    MyLine { a: shape3 b: shape1 node: genConnection("0", "10") }
];

Stage {
    title: "NetFlow"
    scene: Scene {
        width: 800
        height: 600
        content: [
            Rectangle {
                width: 800
                height: 600
                fill: Color.WHITE
                
                onMousePressed: function(e:MouseEvent):Void {
                    if (e.button == MouseButton.PRIMARY) {
                        var shape1:MyShape = MyShape {
                                        node: InnerNode { type: "Source" name: "name" }
                                        position: Point2D { x: e.x y: e.y }
                                        controller: controller
                                    }
                        insert shape1 into controller.items;
                        controller.update();
                    }
                }
            }
            controller
        ]
    }
}

controller.update();

