package netflow.ui;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import netflow.model.MShape;
import javafx.scene.control.Label;

public class UIShape extends UINode {
    public var node:InnerNode = InnerNode { uiShape:this };

    public function getModel():MShape {
        model as MShape;
    }

    var dragBase:Point2D;

    public override var onMouseDragged = function(e:MouseEvent):Void {
        getModel().x = dragBase.x + e.dragX;
        getModel().y = dragBase.y + e.dragY;
        controller.update();
    }

    public override var onMousePressed = function(e:MouseEvent):Void {
        dragBase = Point2D {
            x: getModel().x
            y: getModel().y
        }
        if (e.button == MouseButton.PRIMARY) {
            controller.selectNode(this);
        }
        if (e.button == MouseButton.SECONDARY) {
            if (controller.selected == this) {
                controller.controller.deleteNode(model);
                controller.update();
            } else {
                controller.connectNode(this);
            }
        }
    }

    public function findBoundaryPoint(a:Point2D,b:Point2D):Point2D {
        // a is outside, b is inside
        var m:Point2D = Tools.middle(a,b);
        if (Tools.pointsLenSqr(a, b) < 1.) {
            return m;
        } else {
            var n:Point2D = Point2D {
                x: m.x - getModel().x + width/2
                y: m.y - getModel().y + height/2
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

