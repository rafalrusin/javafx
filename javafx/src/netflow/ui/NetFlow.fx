package netflow.ui;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.layout.Priority;
import javafx.scene.control.Button;
import javafx.geometry.Insets;
import javax.swing.JOptionPane;
import javafx.scene.control.Label;
import netflow.model.Model;
import javafx.scene.control.ChoiceBox;
import java.util.List;
import java.net.URL;
import java.lang.Throwable;
import java.util.ArrayList;

var model:Model = new Model();
var controllerFx: ControllerFx = ControllerFx {}
controllerFx.controller.model = model;

//var urlList:List = new ArrayList();
//urlList.add("http://sites.google.com/site/rrusin999/syntax/simple.xml");
//println(Model.getXStream().toXML(urlList));

var urlList:List = new ArrayList();
try {
    urlList = Model.getXStream().fromXML(new URL("http://sites.google.com/site/rrusin999/syntax/list.xml").openStream()) as List;
} catch (t:Throwable) {
    t.printStackTrace();
}

var maxFlowLabel:Label = Label {}

function updateFx():Void {
    controllerFx.update();
    FX.deferAction(function():Void {
        controllerFx.update();
    });
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
                                            updateFx();
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

                    HBox {
                        spacing: 5
                        padding: {
                            var l=5;
                            Insets { bottom: l top: l left: l right: l }
                        }

                        layoutInfo: LayoutInfo {
                            vgrow: Priority.NEVER
                        }

                        content: 
                        {
                            var b:ChoiceBox = ChoiceBox {
                                layoutInfo: LayoutInfo {
                                    hfill: true
                                }

                                items: for (i in urlList) i as String
                            };
                            [
                                Button {
                                    text: "Open URL"
                                    action: function():Void {
                                        controllerFx.controller.openURL(b.selectedItem as String);
                                        updateFx();
                                    }
                                }
                                b
                            ]
                        }
                        
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
updateFx();
