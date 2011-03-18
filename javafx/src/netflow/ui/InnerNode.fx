package netflow.ui;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextBox;
import javafx.scene.layout.Container;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.control.Label;
import javafx.geometry.VPos;

public class InnerNode extends Container {
    public var selectionColor: Color = Color.LIGHTBLUE;
    public var nameBox: TextBox = TextBox {};
    public var flow: Double = 0;
    public var capacityTextBox: TextBox = TextBox {
        layoutInfo: LayoutInfo {
            width: 30
        }
        text: "10"
    }

    public var typeBox: ChoiceBox = ChoiceBox {
                layoutInfo: LayoutInfo {
                    hfill: true
                }

                items: ["Inner", "Source", "Sink"]
            }

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
        var b =
            VBox {
                padding: Insets { bottom: l top: l left: l right: l }
                spacing: l
                content: [
                    HBox {
                        spacing: l
                        content: [
                            Rectangle {
                                width: 16
                                height: 16
                                fill: Color.GRAY
                                opacity: 0.5
                                arcWidth: 8
                                arcHeight: 8
                            }
                            Label { text: "Node" }
                        ]
                    }


                    VBox {
                        content: [
                            nameBox,
                            typeBox,
                            HBox {
                                visible: bind typeBox.selectedIndex != 0
                                content: [
                                    Label {
                                        layoutInfo: LayoutInfo {
                                            vpos: VPos.CENTER
                                        }

                                        text: bind "Capacity: {flow} / "
                                    }

                                    capacityTextBox
                                ]
                            }
                        ]
                    }
                ]
            }

        content = [
            rect,
            b
        ]
    }
}

