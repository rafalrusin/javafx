package netflow.ui;
import javafx.geometry.Point2D;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;
import javafx.scene.transform.Affine;
import javafx.util.Math;
import netflow.model.MLine;

public class UILine extends UINode {
    public var node:InnerConnection = InnerConnection { uiLine: this };

    public function getModel():MLine {
        model as MLine
    }

    public function isForward():Boolean {
        node.flow > 0.0001
    }

    public function isBackward():Boolean {
        node.flow < -0.0001
    }

    public function rebuild():Void {
        var a:UIShape = controller.render(getModel().a) as UIShape;
        var b:UIShape = controller.render(getModel().b) as UIShape;
        var u:Point2D = a.findBoundaryPoint(Tools.shapePosition(b.getModel()), Tools.shapePosition(a.getModel()));
        var v:Point2D = b.findBoundaryPoint(Tools.shapePosition(a.getModel()), Tools.shapePosition(b.getModel()));

        var l:Float = Math.sqrt(Tools.pointsLenSqr(u, v));


        var path = Path {
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

                if (isForward()) {
                    [
                    MoveTo {
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
                    ]
                } else [],

                if (isBackward()) {
                    [
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
                } else []
            ]
        }

        node.layoutX = path.boundsInParent.width/2 + path.boundsInParent.minX;
        node.layoutY = path.boundsInParent.height/2 + path.boundsInParent.minY;
//        println("conn layout {node.layoutX} {node.layoutY} {path.boundsInLocal}");

        content = [
            path,
            node
        ]
    }

    override public function updateFlow () : Void {
        node.flow = getModel().flow;
    }

    init {
        rebuild();
        updateFlow();
    }
}
