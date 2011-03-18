package netflow.ui;
import javafx.scene.layout.Container;
import netflow.model.MNode;

public abstract class UINode extends Container {
    public var model:MNode;
    public var controller:ControllerFx;

    public abstract function updateFlow():Void;
}
