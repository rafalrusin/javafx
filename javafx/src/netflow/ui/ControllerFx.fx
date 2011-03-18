package netflow.ui;
import javafx.scene.Node;
import javafx.scene.layout.Container;
import java.lang.Void;
import javafx.scene.control.Label;
import netflow.model.Controller;
import netflow.model.MNode;
import netflow.model.MLine;
import netflow.model.MShape;
import javafx.scene.paint.Color;
import java.lang.Throwable;
import javax.swing.JOptionPane;

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

    public function selectNode(n:UINode):Void {
        selected = n;
        for (o:Object in controller.renderedItems.values()) {
            var i:UINode = o as UINode;
            if (i instanceof UIShape) {
                var s:UIShape = i as UIShape;
                if (i == n) {
                    s.node.selectionColor = Color.RED;
                } else {
                    s.node.selectionColor = Color.LIGHTBLUE;
                }
            }
        }
    }

    public function update():Void {
        for (i:MNode in controller.model.nodes) {
            if (i instanceof MShape) {
                var s:UIShape = render(i) as UIShape;
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

        for (i:Node in content) {
            if (i instanceof UILine) {
                var l:UILine = i as UILine;
                l.rebuild();
            }
        }
    }

    public function connectNode(n:UINode):Void {
        if (selected != null) {
            var a:UIShape = selected as UIShape;
            var b:UIShape = n as UIShape;

            controller.connectNodes(a.getModel(), b.getModel());
            update();
        }
    }

    public function calculateFlow():Void {
        try {
            maxFlowLabel.text = "{controller.calculateFlow()}";
            
            for (i:Node in content) {
                if (i instanceof UINode) {
                    var l:UINode = i as UINode;
                    l.updateFlow();
                }
            }
        } catch (t:Throwable) {
            t.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error {t.getMessage()}");
        }
    }
}
