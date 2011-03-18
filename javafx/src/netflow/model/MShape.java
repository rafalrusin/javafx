package netflow.model;

public class MShape extends MNode {
    public static enum ShapeType { INNER, SOURCE, SINK};
    public String name;
    public ShapeType type;
    public double x,y;
}
