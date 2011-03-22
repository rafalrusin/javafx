package netflow.ui;
import javafx.geometry.VPos;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;
import java.lang.Throwable;
import javafx.util.Math;

public class InnerConnection extends HBox {
    public var uiLine:UILine;
    public var flow: Double = 0;
    public var capacityTextBox:TextBox = TextBox {
        layoutInfo: LayoutInfo {
            width: 30
        }
        text: "{uiLine.getModel().capacity}"
    }

    var capacityTextBoxValue:String = bind capacityTextBox.text on replace oldValue {
        try {
            uiLine.getModel().capacity = Double.parseDouble(capacityTextBoxValue)
        } catch (t:Throwable) {
        }
    }

    init {
        content = [
            Label {
                layoutInfo: LayoutInfo {
                    vpos: VPos.CENTER
                }

                text: bind "{Math.abs(flow)} / "
            }
            capacityTextBox
        ]
    }
}
