package netflow.model;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;
import java.util.HashSet;
import java.util.Set;

public class Model {
    public Set<MNode> nodes = new HashSet<MNode>();

    public static XStream getXStream() {
        XStream xstream = new XStream(new DomDriver());
        xstream.setMode(XStream.NO_REFERENCES);
        return xstream;
    }

    public String persist() throws Exception {
        return getXStream().toXML(this);
    }

    public static Model fromString(String data) throws Exception {
        return (Model) getXStream().fromXML(data);
    }
}
