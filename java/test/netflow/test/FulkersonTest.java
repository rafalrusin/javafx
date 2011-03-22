package netflow.test;

import netflow.Fulkerson;
import junit.framework.TestCase;

public class FulkersonTest extends TestCase {
    public void test() {
        Fulkerson g = new Fulkerson();
        g.addEdge("s","o",3,0);
        g.addEdge("s","p",3,0);
        g.addEdge("o","p",2,0);
        g.addEdge("o","q",3,0);
        g.addEdge("p","r",2,0);
        g.addEdge("r","t",3,0);
        g.addEdge("q","r",4,0);
        g.addEdge("q","t",2,0);
        System.out.println(g.maxFlow("s","t"));
        System.out.println(g.flow);
    }
}
