package netflow.model;

public class MShape extends MNode {
    public static enum ShapeType { SOURCE, SINK, INNER };
    public String name;
    public ShapeType type;
    public double x,y;
}
