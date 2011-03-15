package netflow;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;

public class MyShape extends MyNode {
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
        var m:Point2D = Tools.middle(a,b);
        if (Tools.pointsLenSqr(a, b) < 1.) {
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

