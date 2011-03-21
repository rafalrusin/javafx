package netflow.ui;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

public class Drawing extends Container {
    public var controller: ControllerFx;

    public var rect:Rectangle = Rectangle {
        fill: Color.WHITE

        onMousePressed: function(e:MouseEvent):Void {
            if (e.button == MouseButton.PRIMARY) {
                controller.controller.createNode(e.x, e.y);
                controller.update();
            }
        }
    }

    override public function doLayout():Void {
        rect.width = width;
        rect.height = height;
        resizeNode(controller, width, height);
    }

    init {
        content = [rect, controller]
    }
}
