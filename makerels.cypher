 

    
LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (o:order {order_id:line[1]}), (rg:region {region_name:line[12]})
    CREATE UNIQUE (o)-[:SHIPPED_TO]->(rg)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (o:order {order_id:line[1]}), (p:product {product_id:line[13]})
    CREATE UNIQUE (o)-[:HAS]->(p)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (o:order {order_id:line[1]}), (pc:postal_code {postal_code:line[11]})
    CREATE UNIQUE (o)-[:SHIPPED_TO]->(pc)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (pc:postal_code {postal_code:line[11]}), (ci:city {city_name:line[9]})
    CREATE UNIQUE (pc)-[:LOCATED_IN]->(ci)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (ci:city {city_name:line[9]}), (s:state {state_name:line[10]})
    CREATE UNIQUE (ci)-[:LOCATED_IN]->(s)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (s:state {state_name:line[10]}), (co:country {country_name:line[8]})
    CREATE UNIQUE (s)-[:LOCATED_IN]->(co)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (p:product {product_id:line[13]}), (sq:sales {sales_amount:toFloat(line[17])})
    CREATE UNIQUE (p)-[:PURCHASED_FOR]->(sq)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (p:product {product_id:line[13]}), (q:quantity {quantity_value:toInteger(line[18])})
    CREATE UNIQUE (p)-[:CONTAINS]->(q)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line

    MATCH (p:product {product_id:line[13]}), (d:discount {discount_amount:toFloat(line[19])})
    CREATE UNIQUE (p)-[:DISCOUNT_GIVEN]->(d)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line
    MATCH (p:product {product_id:line[13]}), (pf:profit {profit_amount:toFloat(line[20])})
    CREATE UNIQUE (p)-[:PROFIT_EARNED]->(pf)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line
    MATCH (p:product {product_id:line[13]}), (sb:sub_category {sub_category_name:line[15]})
    CREATE UNIQUE (p)-[:BELONGS_TO]->(sb)

LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line
    MATCH (sb:sub_category {sub_category_name:line[15]}), (ca:category {category_name:line[14]})
    CREATE UNIQUE (sb)-[:BELONGS_TO]->(ca)
    
    LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line
    MATCH (p:product {product_id:line[13]}), (sg:segment {segment_name:line[7]})
    CREATE UNIQUE (p)-[:BELONGS_TO]->(sg)


  LOAD CSV FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTFsWb6nCp3vvKZ0jGetOEamRgh1O9YVOMazNJX6nAHyYmxiivOYp5UKmHF20FknYadnI0YZoWBbuI0/pub?output=csv' AS line
    MATCH (c:customer {customer_id:line[5]}), (o:order {order_id:line[1]})
    CREATE UNIQUE (c)-[:PURCHASED]->(o)

    