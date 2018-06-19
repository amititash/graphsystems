
// GraphFromCSV.java
//
// Simple example of using TinkerGraph with Java
//
// This example does the following:
//   1. Create an empty TinkerGraph instance
//   2. Reads simple edge lists from a CSV file
//   3. Creates a graph - avoiding creating any duplicate vertices or edges
//   4. Displays information about the graph that was created

// The csv file is expected to be of the form:
//   Kelvin,knows,Jack
//   Jack,knows,Baxter
//
// Each name in the CSV file is assumed to be unique for this simple examplei, so for
// example only one node will be created for Jack in the example above.

// I have highlighted any places where the Gremlin is slightly different from the 
// Gremlin we can use in the Gremlin Console.

import org.apache.tinkerpop.gremlin.process.traversal.dsl.graph.GraphTraversalSource;
import org.apache.tinkerpop.gremlin.process.traversal.dsl.graph.__;
import org.apache.tinkerpop.gremlin.process.traversal.Path;
import org.apache.tinkerpop.gremlin.process.traversal.*;
import org.apache.tinkerpop.gremlin.structure.Edge;
import org.apache.tinkerpop.gremlin.structure.Vertex;
import org.apache.tinkerpop.gremlin.structure.io.IoCore;
import org.apache.tinkerpop.gremlin.tinkergraph.structure.*;
import org.apache.tinkerpop.gremlin.structure.T;
import org.apache.tinkerpop.gremlin.util.Gremlin;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;
import java.io.*;

public class GraphFromCSV
{
 
  private TinkerGraph tg;
  private GraphTraversalSource g;

  // Try to create a new empty graph instance
  public boolean createGraph()
  {
    tg = TinkerGraph.open() ;
    g = tg.traversal();
    
    if (tg == null || g==null)
    {
      return false;
    }
    return true;
  }

  // Add the specified vertices and edge. Do not add anything that 
  // already exists.
/**
 0 Row ID	
 1 Order ID	
 2 Order Date	
 3 Ship Date	
 4 Ship Mode	
 5 Customer ID	
 6 Customer Name	
 7 Segment	
 8 Country	
 9 City	
 10 State	
 11 Postal Code	
 12 Region	
 13 Product ID	
 14 Category	
 15 Sub-Category	
 16 Product Name	
 17 Sales	Quantity	
 18 Discount	
 19 Profit
  */
  										
  public boolean addElements(String line)
  {

     String [] values;
     
    if (tg == null || g==null)
    {
      return false;
    }

    values = line.split(",");
    //split - addElements(values[0],values[1],values[2]);

    // First make all the nodes and then make all the edges
    Vertex order = 
      g.V().has("order_id",values[1]).fold().
            coalesce(__.unfold(),__.addV().property("order_id",values[1], "label", "order",
            "order_date", values[2], "ship_date", values[3], "ship_mode", values[4])).next();
    
    Vertex product = 
      g.V().has("product_id",values[13]).fold().
            coalesce(__.unfold(),__.addV().property("product_id",values[13], "label", "product",
            "product_name", values[16])).next();
    
      Vertex customer = 
      g.V().has("customer_id",values[5]).fold().
            coalesce(__.unfold(),__.addV().property("customer_id",values[5], "label", "customer",
            "customer_name", values[6])).next();
    
    Vertex category = 
      g.V().has("category_name",values[14]).fold().
            coalesce(__.unfold(),__.addV().property("category_name",values[14], "label", "category")).next();
    
    Vertex sub_category = 
      g.V().has("sub_category_name",values[15]).fold().
            coalesce(__.unfold(),__.addV().property("sub_category_name",values[15], "label", "sub_category")).next();

    Vertex region = 
      g.V().has("region_name",values[12]).fold().
            coalesce(__.unfold(),__.addV().property("region_name",values[12], "label", "region")).next();
    
    Vertex segment = 
      g.V().has("segment_name",values[7]).fold().
            coalesce(__.unfold(),__.addV().property("segment_name",values[7], "label", "segment")).next();

     Vertex postal_code = 
      g.V().has("postal_code",values[11]).fold().
            coalesce(__.unfold(),__.addV().property("postal_code",values[11], "label", "postal_code")).next();

     Vertex city = 
      g.V().has("city_name",values[9]).fold().
            coalesce(__.unfold(),__.addV().property("city_name",values[9], "label", "city")).next();
    
    Vertex state = 
      g.V().has("state_name",values[10]).fold().
            coalesce(__.unfold(),__.addV().property("state_name",values[10], "label", "state")).next();
    
    Vertex country = 
      g.V().has("country_name",values[8]).fold().
            coalesce(__.unfold(),__.addV().property("country_name",values[8], "label", "country")).next();

  // for sales discount and profit we can have multiple nodes with same values - might change in future based on testing

  /* Vertex sales = 
      g.V().has().fold().
            coalesce(__.unfold(),__.addV().property("sales_quantity",values[17], "label", "sales")).next();
 */
   Vertex sales = tg.addVertex("label", "sales", "sales_quantity", values[17]);
    //Vertex sales = g.addV().property("label", "sales", "sales_quantity", values[17]);
    Vertex discount = tg.addVertex("label", "discount", "discount_amount", values[18]);
    Vertex profit = tg.addVertex("label", "profit", "profit_amount", values[19]);
    
// Now create all the edges defining properties and relatinships
    
     // Create an edge between 'customer' and 'order' as purchased unless it exists already
     String label = "purchased";
    g.V().has("customer_id",values[5]).out(label).has("order_id",values[1]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(customer)).to(__.V(order))).iterate();

     // Create an edge between 'order' and 'region' as shipped_to unless it exists already
     label = "shipped_to";
    g.V().has("order_id",values[1]).out(label).has("region_name",values[12]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(order)).to(__.V(region))).iterate();

     // Create an edge between 'order' and 'product' as contains unless it exists already
     label = "contains";
    g.V().has("order_id",values[1]).out(label).has("product_id",values[13]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(order)).to(__.V(product))).iterate();

     // Create an edge between 'order' and 'postal_code' as shipped_to unless it exists already
     label = "shipped_to";
    g.V().has("order_id",values[1]).out(label).has("postal_code",values[11]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(order)).to(__.V(postal_code))).iterate();

     // Create an edge between 'postal_code' and 'city' located_in it exists already
     label = "located_in";
    g.V().has("postal_code",values[11]).out(label).has("city_name",values[9]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(postal_code)).to(__.V(city))).iterate();
    
     // Create an edge between 'city' and 'state' located_in unless it exists already
     label = "located_in";
    g.V().has("city_name",values[9]).out(label).has("state_name",values[10]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(city)).to(__.V(state))).iterate();
    
    // Create an edge between 'state' and 'country' located_in unless it exists already
    label = "located_in";
    g.V().has("state_name",values[10]).out(label).has("country_name",values[8]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(state)).to(__.V(country))).iterate();

    // Create an edge between 'order' and 'sales_quantity' purchased_for unless it exists already
    label = "purchased_for";
    g.V().has("order_id",values[1]).out(label).has("sales_quantity",values[17]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(order)).to(__.V(sales))).iterate();
    
    // Create an edge between 'order' and 'discount' discount_given unless it exists already
    label = "discount_given";
    g.V().has("order_id",values[1]).out(label).has("discount_amount",values[18]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(order)).to(__.V(discount))).iterate();
    
    // Create an edge between 'order' and 'profit' profit_earned unless it exists already
    label = "profit_earned";
    g.V().has("order_id",values[1]).out(label).has("profit_amount",values[19]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(order)).to(__.V(profit))).iterate();

     // Create an edge between 'product' and 'sub_category' belongs_to unless it exists already
    label = "belongs_to";
    g.V().has("product_id",values[13]).out(label).has("sub_category_name",values[15]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(product)).to(__.V(sub_category))).iterate();
    
     // Create an edge between 'sub_category' and 'category' belongs_to unless it exists already
    label = "belongs_to";
    g.V().has("sub_category_name",values[15]).out(label).has("category_name",values[14]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(sub_category)).to(__.V(category))).iterate();
    
     // Create an edge between 'product' and 'segment' belongs_to unless it exists already
    label = "belongs_to";
    g.V().has("product_id",values[13]).out(label).has("segment_name",values[7]).fold().
          coalesce(__.unfold(),
                   __.addE(label).from(__.V(product)).to(__.V(segment))).iterate();

    return true;
  }

  public void displayGraph()
  {
    Long c;
    c = g.V().count().next();
    System.out.println("Graph contains " + c + " vertices");
    c = g.E().count().next();
    System.out.println("Graph contains " + c + " edges");

    // Save the graph we just created as GraphML (XML) or GraphSON (JSON)
    try
    {
      // If you want to save the graph as GraphML uncomment the next line
      tg.io(IoCore.graphml()).writeGraph("mygraph.graphml");
      System.out.println("Graph saved");
      
      // If you want to save the graph as JSON uncomment the next line
      //tg.io(IoCore.graphson()).writeGraph("mygraph.json");
    }
    catch (IOException ioe)
    {
      System.out.println("Graph failed to save");
    }

    /* List<Path> edges = g.V().outE().inV().path().by("label").by().toList();

    for (Path p : edges)
    {
      System.out.println(p);
    } */
  }


  // Open the sample csv file and build a graph based on its contents

  public static void main(String[] args) 
  {
    GraphFromCSV gcsv = new GraphFromCSV();
    
     System.out.println("starting...");
    if (gcsv.createGraph())
    {
      try 
      {
        String line;
        //String [] values;

        FileReader fileReader = new FileReader("orders.csv");

        BufferedReader bufferedReader = new BufferedReader(fileReader);

        while((line = bufferedReader.readLine()) != null) 
        {
          System.out.println(line);
         // values = line.split(",");
          gcsv.addElements(line);
        }
        
      
        gcsv.displayGraph();
        bufferedReader.close();         
      }
      catch( Exception e ) 
      {
        System.out.println("Unable to open file" + e.toString());
        //e.printStackTrace();
      }
    }  
  }      
}