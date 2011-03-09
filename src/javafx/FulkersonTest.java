package javafx;

public class FulkersonTest {
    public void run() {
        Fulkerson g = new Fulkerson();
        g.addEdge("s","o",3);
        g.addEdge("s","p",3);
        g.addEdge("o","p",2);
        g.addEdge("o","q",3);
        g.addEdge("p","r",2);
        g.addEdge("r","t",3);
        g.addEdge("q","r",4);
        g.addEdge("q","t",2);
        System.out.println(g.maxFlow("s","t"));
        System.out.println(g.flow);
    }
}
