package javafx;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.Group;
import javafx.fxd.FXDLoader;
import javafx.scene.Node;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseEvent;
import javafx.scene.shape.Path;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.LineTo;
import javafx.util.Math;
import javafx.scene.transform.Affine;

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
    public var name:String;
    public var position:Point2D;

    public var s:Node;

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
        s = FXDLoader.load("{__DIR__}{name}.fxz");
        s.translateX = -s.boundsInLocal.width/2;
        s.translateY = -s.boundsInLocal.height/2;
        updatePosition();
        content = [ s ]
    }
}

class MyLine extends MyNode {
    override function update () : Void {
        rebuild();
    }

    public var a:MyShape;
    public var b:MyShape;

    public function rebuild():Void {
        var u:Point2D = a.findBoundaryPoint(b.position, a.position);
        var v:Point2D = b.findBoundaryPoint(a.position, b.position);

        var l:Float = Math.sqrt(pointsLenSqr(u, v));

        content = [
            Path {
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
        ]
    }

    init {
        rebuild();
    }
}

var controller: MyController = MyController {}

var shape1:MyShape = MyShape {
                name: "shape1"
                position: Point2D { x: 50 y: 300 }
                controller: controller
            }
var shape2:MyShape = MyShape {
                name: "shape2"
                position: Point2D { x: 750 y: 100 }
                controller: controller
            }
var shape3:MyShape = MyShape {
                name: "shape3"
                position: Point2D { x: 750 y: 500 }
                controller: controller
            }

controller.items = [
    shape1,
    shape2,
    shape3,
    MyLine { a: shape1 b: shape2 }
    MyLine { a: shape2 b: shape3 }
    MyLine { a: shape3 b: shape1 }
];

Stage {
    title: "Arrows"
    scene: Scene {
        width: 800
        height: 600
        content: controller.items
    }
}

