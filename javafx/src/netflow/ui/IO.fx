package netflow.ui;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.scene.layout.LayoutInfo;
import javafx.scene.control.Button;
import javafx.scene.control.TextBox;

public function io(data:String, action:function(String):Void):Void {
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
                    }
                    TextBox {
                        multiline: true
                    }
                ]
            }
        ]
    }

    Stage {
        title: "Import / Export"
        scene: scene
    }
}
