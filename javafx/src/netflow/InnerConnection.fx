package netflow;
import javafx.geometry.VPos;
import javafx.scene.control.Label;
import javafx.scene.control.TextBox;
import javafx.scene.layout.HBox;
import javafx.scene.layout.LayoutInfo;

public class InnerConnection extends HBox {
    public var flow: Double = 0;
    public var capacityBox:TextBox = TextBox {
        layoutInfo: LayoutInfo {
            width: 30
        }
        text: "10"
    }

    init {
        content = [
            Label {
                layoutInfo: LayoutInfo {
                    vpos: VPos.CENTER
                }

                text: bind "{flow} / "
            }
            capacityBox
        ]
    }
}
