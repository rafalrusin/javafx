package netflow.ui;

import javafx.stage.Stage;
import javafx.scene.Scene;
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
import javax.swing.JOptionPane;
import javafx.scene.control.Label;
import netflow.model.Model;

var model:Model = new Model();
var controllerFx: ControllerFx = ControllerFx {}
controllerFx.controller.model = model;

class Drawing extends Container {
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

var maxFlowLabel:Label = Label {}

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
                                action: function() {
                                    controllerFx.calculateFlow();
                                }
                            }
                            Label {
                                text: "Max Flow: "
                            }
                            maxFlowLabel,

                            Button {
                                text: "Import / Export"
                                action: function() {
                                    IO { 
                                        data: controllerFx.controller.model.persist()
                                        action: function(v:String):Void {
                                            var m:Model = Model.fromString(v);
                                            controllerFx.controller.model = m;
                                            controllerFx.update();
                                        }
                                    };
                                }
                            }

                            Button {
                                text: "Help"
                                action: function() {
                                    JOptionPane.showMessageDialog(null, "msg");
                                }
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

                        controller: controllerFx
                    }
                ]
            }
        ]
    }

Stage {
    title: "NetFlow"
    scene: scene
}

controllerFx.maxFlowLabel = maxFlowLabel;
controllerFx.update();

FX.deferAction(function():Void {
    controllerFx.update();
});
