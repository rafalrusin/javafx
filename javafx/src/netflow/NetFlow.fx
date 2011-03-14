package netflow;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.Group;
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
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.geometry.Insets;
import javafx.scene.layout.HBox;

abstract class MyNode extends Group {
    abstract function update():Void;
}

class MyController {
    public var items:MyNode[];

    public function update():Void {
        for (i:MyNode in items) {
            i.update();
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
    public var node:Node;
    public var position:Point2D;

//    public var s:Node;

    public function updatePosition():Void {
        translateX = position.x;
        translateY = position.y;
    }

    var dragBase:Point2D;

    override function update () : Void {
        updatePosition();
    }

    public override var onMouseDragged = function(e:MouseEvent):Void {
        position = Point2D {
            x: dragBase.x + e.dragX
            y: dragBase.y + e.dragY
        }
        controller.update();
    }

    public override var onMousePressed = function(e:MouseEvent):Void {
        dragBase = position;
    }

    public function findBoundaryPoint(a:Point2D,b:Point2D):Point2D {
        // a is outside, b is inside
        var m:Point2D = middle(a,b);
        if (pointsLenSqr(a, b) < 1.) {
            return m;
        } else {
            var n:Point2D = Point2D {
                x: m.x - position.x
                y: m.y - position.y
            }

            if (contains(n)) {
                return findBoundaryPoint(a,m);
            } else {
                return findBoundaryPoint(m,b);
            }
        }
    }

    init {
        translateX = -node.boundsInLocal.width/2;
        translateY = -node.boundsInLocal.height/2;
        println("{translateX} {translateY}");
        updatePosition();
        content = [
            node
        ]
    }
}

class MyLine extends MyNode {
    public var node:Node;
    
    override function update () : Void {
        rebuild();
    }

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

function genNode(type: String, name: String) {
    var l=5;
    var b=VBox {
        padding: Insets { bottom: l top: l left: l right: l }
        content: [
            Label { text: type }
            TextBox { text: name }
        ]
    }
    Group {
        content: [
            Rectangle {
                width: bind b.width
                height: bind b.height
                fill: Color.LIGHTBLUE
                stroke: Color.BLACK
                strokeWidth: 0.5
                arcHeight: 10
                arcWidth: 10
            }
            b
            ]
    }
}

function genConnection(flow: String, maxFlow: String):Node {
    HBox {
        content: [
            Label { text: "{flow} / " }
            TextBox { text: maxFlow }
            ]
    }
}


var shape1:MyShape = MyShape {
                node: genNode("Source", "name")
                position: Point2D { x: 50 y: 300 }
                controller: controller
            }
var shape2:MyShape = MyShape {
                node: genNode("Sink", "name")
                position: Point2D { x: 750 y: 100 }
                controller: controller
            }
var shape3:MyShape = MyShape {
                node: genNode("Node", "name")
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
        content: controller.items
    }
}

