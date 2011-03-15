package netflow;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseEvent;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.input.MouseButton;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Priority;
import javafx.scene.control.Button;
import javafx.scene.layout.Container;
import javafx.geometry.Insets;

var controller: MyController = MyController {}

class Drawing extends Container {
    public var controller: MyController;

    public var rect:Rectangle = Rectangle {
        fill: Color.WHITE

        onMousePressed: function(e:MouseEvent):Void {
            if (e.button == MouseButton.PRIMARY) {
                controller.createNode(e);
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

var scene:Scene = Scene {
        width: 800
        height: 600
        content: [
            VBox {
                layoutInfo: LayoutInfo {
                    width: bind scene.width
                    height: bind scene.height
                }
                content: [
                    HBox {
                        spacing: 5
                        padding: {
                            var l=5;
                            Insets { bottom: l top: l left: l right: l }
                        }
                        
                        layoutInfo: LayoutInfo {
                            vgrow: Priority.NEVER
                        }

                        content: [
                            Button {
                                text: "Calculate Flow"
                            }
                            Button {
                                text: "Help"
                            }
                        ]
                    }

                    Drawing {
                        layoutInfo: LayoutInfo {
                            hfill: true
                            vfill: true
                            hgrow: Priority.ALWAYS
                            vgrow: Priority.ALWAYS
                        }

                        controller: controller
                    }
                ]
            }
        ]
    }

Stage {
    title: "NetFlow"
    scene: scene
}

controller.update();

FX.deferAction(function():Void {
    controller.update();
});
