package netflow.ui;
import javafx.scene.Node;
import javafx.scene.layout.Container;
import javafx.scene.paint.Color;
import java.lang.Void;
import javafx.geometry.Point2D;
import javafx.scene.input.MouseEvent;
import javafx.scene.control.Label;
import java.lang.Throwable;
import javax.swing.JOptionPane;
import java.util.HashMap;
import java.util.Map;
import java.util.WeakHashMap;
import netflow.model.Controller;
import netflow.model.MNode;
import netflow.model.MLine;
import netflow.model.MShape;

public class ControllerFx extends Container {
    public var maxFlowLabel:Label;
    public var controller:Controller = new Controller();

    public var selected:UINode = null;

    public function render(i:MNode):UINode {
        if (controller.renderedItems.containsKey(i)) {
            return controller.renderedItems.get(i) as UINode;
        } else {
            var uiNode: UINode;
            if (i instanceof MShape) {
                uiNode = UIShape {
                    model: i
                    controller: this
                }
            } else if (i instanceof MLine) {
                uiNode = UILine {
                    model: i
                    controller: this
                }
            }

            controller.renderedItems.put(i, uiNode);
            return uiNode;
        }
    }


    public function update():Void {
        for (i:MNode in controller.model.nodes) {
            if (i instanceof MShape) {
                render(i);
            }
        }
        for (i:MNode in controller.model.nodes) {
            if (i instanceof MLine) {
                render(i);
            }
        }
        
        content = for (i:Object in controller.renderedItems.values()) {
            i as UINode
        }

        requestLayout();
    }


    override public function doLayout():Void {
        for (i:Node in getManaged(content)) {
            if (i instanceof UIShape) {
                var k:UIShape = i as UIShape;
                layoutNode(i,0,0,getNodePrefWidth(i),getNodePrefHeight(i));
                positionNode(i, -getNodePrefWidth(i)/2 + k.getModel().x, -getNodePrefHeight(i)/2 + k.getModel().y);
            }
        }

//        for (i:MyNode in items) {
//            if (i instanceof MyLine) {
//                var l:MyLine = i as MyLine;
//                l.rebuild();
//            }
//        }
    }

}
