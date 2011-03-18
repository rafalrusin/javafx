package netflow.ui;
import javafx.geometry.Point2D;
import javafx.geometry.VPos;
import javafx.scene.Node;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import netflow.model.MShape;

public function pointsLenSqr(a:Point2D,b:Point2D):Float {
    return (a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y);
}

public function middle(a:Point2D,b:Point2D):Point2D {
    return Point2D {
        x: (a.x+b.x)/2
        y: (a.y+b.y)/2
    }
}

public function genConnection(flow: String, maxFlow: String):Node {
    HBox {
        content: [
            Label {
                layoutInfo: LayoutInfo {
                    vpos: VPos.CENTER
                }

                text: "{flow} / "
            }
            TextBox {
                layoutInfo: LayoutInfo {
                    width: 30
                }
                text: maxFlow
            }
            ]
    }
}

public function shapePosition(i:MShape):Point2D {
    Point2D {
        x: i.x
        y: i.y
    }
}
