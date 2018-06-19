 

    
LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MERGE (:order { order_id: line[1],order_date: line[2],ship_date: line[3], ship_mode: line[4]})

    MERGE (:product { product_id: line[13], product_name: line[16]})
    MERGE (:customer { customer_id: line[5], customer_name: line[6]})    
    MERGE (:category { category_name: line[14]})
    MERGE (:sub_category { sub_category_name: line[15]})
    MERGE (:region { region_name: line[12]})
    MERGE (:segment { segment_name: line[7]})
    MERGE (:postal_code { postal_code: line[11]})
    MERGE (:city { city_name: line[9]})
    MERGE (:state { state_name: line[10]})
    MERGE (:country { country_name: line[8]})
    MERGE (:sales { sales_amount: toFloat(line[17])})
    MERGE (:quantity {quantity_value: toInteger(line[18])})
    MERGE (:discount { discount_amount:toFloat(line[19])})
    MERGE (:profit { profit_amount: toFloat(line[20])})

    // Now create all the edges defining properties and relatinships
    
    WITH customer, order
    MATCH (c:customer {customer_id:line[5]}), (o:order {order_id:line[1]})
    CREATE (c)-[:PURCHASED]->(o)
    
    WITH order, region
    MATCH (o:order {order_id:line[1]}), (rg:region {region_name:line[12]})
    CREATE (o)-[:SHIPPED_TO]->(rg)

    WITH order, product
    MATCH (o:order {order_id:line[1]}), (p:product {product_id:line[13]})
    CREATE (o)-[:CONTAINS]->(p)

    WITH order, postal_code
    MATCH (o:order {order_id:line[1]}), (pc:postal_code {postal_code:line[11]})
    CREATE (o)-[:SHIPPED_TO]->(pc)

    WITH postal_code, city
    MATCH (pc:postal_code {postal_code:line[11]}), (ci:city {city_name:line[9]})
    CREATE (pc)-[:LOCATED_IN]->(ci)

    WITH city, state
    MATCH (ci:city {city_name:line[9]}), (s:state {state_name:line[10]})
    CREATE (ci)-[:LOCATED_IN]->(s)

    WITH state, country
    MATCH (s:state {state_name:line[10]}), (co:country {country_name:line[8]})
    CREATE (s)-[:LOCATED_IN]->(co)
    
    WITH order, sales
    MATCH (o:order {order_id:line[1]}), (sq:sales {sales_quantity:line[17]})
    CREATE (o)-[:PURCHASED_FOR]->(sq)

    WITH order, discount
    MATCH (o:order {order_id:line[1]}), (d:discount {discount_amount:line[18]})
    CREATE (o)-[:DISCOUNT_GIVEN]->(d)

    WITH order, profit
    MATCH (o:order {order_id:line[1]}), (pf:profit {profit_amount:line[19]})
    CREATE (o)-[:PROFIT_EARNED]->(pf)

    WITH product, sub_category
    MATCH (p:product {product_id:line[13]}), (sb:sub_category {sub_category_name:line[15]})
    CREATE (p)-[:BELONGS_TO]->(sb)

    WITH sub_category, sub_category_name
    MATCH (sb:sub_category {sub_category_name:line[15]}), (ca:category {category_name:line[14]})
    CREATE (cb)-[:BELONGS_TO]->(ca)
    
    WITH product, segment
    MATCH (p:product {product_id:line[13]}), (sg:segment {segment_name:line[7]})
    CREATE (p)-[:BELONGS_TO]->(sg)
