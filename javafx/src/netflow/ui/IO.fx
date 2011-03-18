package netflow.ui;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.control.Button;
import javafx.scene.control.TextBox;

public class IO {
    public var data:String;
    public var action:function(String):Void;

    var textBox:TextBox = TextBox {
        text: data
        multiline: true
    }

    var scene:Scene = Scene {
        width: 600
        height: 500
        content: [
            VBox {
                layoutInfo: LayoutInfo {
                    width: bind scene.width
                    height: bind scene.height
                }
                content: [
                    Button {
                        text: "OK"
                        action: function():Void {
                            stage.close();
                            action(textBox.text);
                        }
                    }
                    textBox
                ]
            }
        ]
    }

    var stage:Stage = Stage {
        title: "Import / Export"
        scene: scene
    }
}


