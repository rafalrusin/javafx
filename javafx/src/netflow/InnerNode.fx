package netflow;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextBox;
import javafx.scene.layout.Container;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

public class InnerNode extends Container {
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
                ChoiceBox {
                    items: [ "Node", "Source", "Sink" ]
                }
                TextBox { text: name }
            ]
        }

        content = [
            rect,
            b
        ]
    }
}

