package netflow;

import javafx.stage.Stage;
import javafx.scene.Scene;
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
import javafx.scene.layout.LayoutInfo;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.geometry.Insets;
import javafx.scene.layout.HBox;
import javafx.geometry.VPos;
import javafx.scene.layout.Container;
import javafx.scene.input.MouseButton;

var controller: MyController = MyController {}


var shape1:MyShape = MyShape {
                node: InnerNode { type: "Source" name: "name" }
                position: Point2D { x: 50 y: 300 }
                controller: controller
            }
var shape2:MyShape = MyShape {
                node: InnerNode { type: "Source" name: "name" }
                position: Point2D { x: 750 y: 100 }
                controller: controller
            }
var shape3:MyShape = MyShape {
                node: InnerNode { type: "Source" name: "name" }
                position: Point2D { x: 750 y: 500 }
                controller: controller
            }

controller.items = [
    shape1,
    shape2,
    shape3,
    MyLine { a: shape1 b: shape2 node: Tools.genConnection("0", "10") }
    MyLine { a: shape2 b: shape3 node: Tools.genConnection("0", "10") }
    MyLine { a: shape3 b: shape1 node: Tools.genConnection("0", "10") }
];

Stage {
    title: "NetFlow"
    scene: Scene {
        width: 800
        height: 600
        content: [
            Rectangle {
                width: 800
                height: 600
                fill: Color.WHITE
                
                onMousePressed: function(e:MouseEvent):Void {
                    if (e.button == MouseButton.PRIMARY) {
                        var shape1:MyShape = MyShape {
                                        node: InnerNode { type: "Source" name: "name" }
                                        position: Point2D { x: e.x y: e.y }
                                        controller: controller
                                    }
                        insert shape1 into controller.items;
                        controller.update();
                    }
                }
            }
            controller
        ]
    }
}

controller.update();

