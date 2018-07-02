 
// Version 0.1 of the salesforce to cypher schema - 
    
    // Accounts table schema

   LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?output=csv' AS line
     
    MERGE (:account { account_id: line.Id, account_name: line.Name, phone: line.Phone, fax: line.Fax, 
    account_number: coalesce(line.AccountNumber, "none"), website: coalesce(line.Website, "none"), sic: coalesce(line.Sic, "none"), 
    annual_revenue: coalesce(line.AnnualRevenue, "none"), number_employee: coalesce(line.NumberOfEmployees, "none"),
    ticker_symbol: coalesce(line.TickerSymbol, "none"), description: coalesce(line.Description, "none"), 
    created_date: coalesce(line.CreatedDate, "non") })
  
    WITH line
    WHERE NOT line.Type IS NULL
    MERGE (:account_type { type_label: line.Type})

    MERGE (:billing_location{ billing_street: line.BillingStreet, postal_code: coalesce(line.PostalCode, "none")})

    MERGE (:shipping_location{ shipping_street: coalesce(line.ShippingStreet, "none"), postal_code:  coalesce(line.PostalCode, "none")})
    
    WITH line
    WHERE NOT line.BillingCity IS NULL
    MERGE (:city { city_name: line.BillingCity})

    WITH line
    WHERE NOT line.BillingState IS NULL
    MERGE (:state { state_name: line.BillingState})

    WITH line
    WHERE NOT line.BillingCountry IS NULL
    MERGE (:country { country_name: line.BillingCountry})




    // Account table entities relationship
    
       
LOAD CSV WITH headers FROM '' AS line

MATCH (a:account {account_id: line.Id}), (at:account_type {type_label: line.Type})
CREATE (a)-[:IS_TYPE]->(at)

   
LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?output=csv' AS line

MATCH (a:account {account_id: line.Id}), (ab:billing_location {billing_street: line.BillingStreet})
CREATE (a)-[:IS_BILLED]->(ab)

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?output=csv' AS line

MATCH (a:account {account_id: line.Id}), (sh:shipping_location {shipping_street: line.ShippingStreet})
CREATE (a)-[:IS_SHIPPED]->(sh)

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?output=csv' AS line

MATCH (sh:shipping_location {shipping_street: line.ShippingStreet}), (c:city {city_name: line.ShippingCity})
CREATE (sh)-[:LOCATED_IN]->(c)


LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?output=csv' AS line

MATCH (c:city {city_name: line.BillingCity}), (s:state {state_name: line.BillingState})
CREATE (c)-[:LOCATED_IN]->(s)

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?output=csv' AS line

MATCH (co:country {country_name: line.BillingCountry}), (s:state {state_name: line.BillingState})
CREATE (s)-[:LOCATED_IN]->(co)

// Opportunity table schema

   
   LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=264684863&single=true&output=csv' AS line
     
    MERGE (:opportunity { opportunity_id: line.Id, opportunity_name: line.Name, amount: coalesce(toInteger(line.Amount), "none"), 
    probability: toFloat(coalesce(line.Probability, 0)), expected_revenue: coalesce(toInteger(line.ExpectedRevenue), "none"), close_date: coalesce(line.CloseDate, "none"), 
    is_closed: coalesce(line.IsClosed, "none"), is_won: coalesce(line.IsWon, "none"),
    fiscal_year: coalesce(line.FiscalYear, "none"), fiscal_quarter: coalesce(line.FiscalQuarter, "none"), 
    tracking_number: coalesce(line.TrackingNumber, "none") })

    WITH line
    WHERE NOT line.StageName IS NULL
    MERGE (:opportunity_stage { stage_name: line.StageName})

    WITH line
    WHERE NOT line.Type IS NULL
    MERGE (:opportunity_type { type_name: line.Type})

    WITH line
    WHERE NOT line.LeadSource IS NULL
    MERGE (:lead_source {source_name: line.LeadSource})

    WITH line
    WHERE NOT line.DeliveryInstallationStatus IS NULL
    MERGE (:delivery_installation_status {status_label: line.DeliveryInstallationStatus})

    MERGE (:billing_location{ billing_street: line.BillingStreet, postal_code: coalesce(line.PostalCode, "none")})

// Opportunity relationship


 LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=264684863&single=true&output=csv' AS line

MATCH acc = (a:account {account_id: line.AccountId}), (o:opportunity {opportunity_id: line.Id})
MERGE (a)-[:HAS_OPPORTUNITY]->(o)

 LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=264684863&single=true&output=csv' AS line
MATCH (o:opportunity {opportunity_id:line.Id}), (os:opportunity_stage {stage_name:line.StageName})
CREATE (o)-[:IS_IN]->(os)

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=264684863&single=true&output=csv' AS line
MATCH (o:opportunity {opportunity_id:line.Id}), (ot:opportunity_type {type_name:line.Type})
CREATE (o)-[:IS_OF]->(ot)

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=264684863&single=true&output=csv' AS line
MATCH (o:opportunity {opportunity_id:line.Id}), (ls:lead_source {source_name:line.LeadSource})
CREATE (o)-[:IS_FROM]->(ls)

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=264684863&single=true&output=csv' AS line
MATCH (o:opportunity {opportunity_id:line.Id}), (ds:delivery_installation_status {status_label:line.DeliveryInstallationStatus})
CREATE (o)-[:IS_IN]->(ds)

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=264684863&single=true&output=csv' AS line
MATCH (o:opportunity {opportunity_id:line.Id}), (bl:billing_location {postal_code:line.PostalCode})
CREATE (o)-[:IS_FROM]->(bl)







// Case table schema

   
   LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=589265446&single=true&output=csv' AS line
     
    MERGE (:case { case_id: line.Id, case_number: line.CaseNumber, email: coalesce(line.SuppliedEmail, "none"), 
    phone: coalesce(line.SuppliedPhone, 0), status: line.Status, reason: line.Reason, 
    is_closed: coalesce(line.IsClosed, 0), subject: line.Subject, priority: line.Priority,
    close_date: coalesce(line.ClosedDate, "none"), is_escalated: coalesce(line.IsEscalated, 0), 
    tracking_number: coalesce(line.TrackingNumber, "none") })


    WITH line
    WHERE NOT line.Type IS NULL
    MERGE (:case_type { type_name: line.Type})

    WITH line
    WHERE NOT line.Origin IS NULL
    MERGE (:case_origin { origin_name: line.Origin})

    // case relationship


 LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=589265446&single=true&output=csv' AS line

MATCH acc = (c:case {case_id: line.Id}), (a:account {account_id: line.AccountId})
MERGE (c)-[:BELONGS_TO]->(a)

 LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=589265446&single=true&output=csv' AS line
MATCH (c:case {case_id:line.Id}), (ct:case_type {type_name:line.Type})
CREATE (c)-[:BELONGS_TO]->(ct)

 LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=589265446&single=true&output=csv' AS line
MATCH (c:case {case_id:line.Id}), (co:case_origin {origin_name:line.Origin})
CREATE (c)-[:ORIGINATED_FROM]->(co)

 LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=589265446&single=true&output=csv' AS line
MATCH (c:case {case_id:line.Id}), (u:user {user_id:line.OwnerId})
CREATE (c)-[:OWNED_BY]->(u)



// Contact table schema

   
LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=1582436887&single=true&output=csv' AS line
     
    MERGE (:contact { contact_id: line.Id, salutation: line.Salutation, first_name: line.FirstName, last_name: line.LastName, 
    email: coalesce(line.Email, "none"), phone: coalesce(line.Phone, 0), is_deleted: line.IsDeleted })


    WITH line
    WHERE NOT line.LeadSource IS NULL
    MERGE (:lead_source { source_name: line.LeadSource})


// contact relationship


 LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=1582436887&single=true&output=csv' AS line

MATCH acc = (co:contact {contact_id: line.Id}), (a:account {account_id: line.AccountId})
MERGE (co)-[:BELONGS_TO]->(a)


// User table schema


LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=1598879432&single=true&output=csv' AS line
     
    MERGE (:user { user_id: line.Id, username: line.Username, first_name: coalesce(line.FirstName, "non"), last_name: line.LastName, 
    email: coalesce(line.Email, "none") })


// product table schema

   
LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=1893652539&single=true&output=csv' AS line
     
    MERGE (:product { product_id: line.Id, product_code: line.ProductCode, product_name: coalesce(line.ProductName, "none") })

LOAD CSV WITH headers FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTtQeSU7tJnIPr3IpugbQvn6cO6kmPnbrTrA2ivsBkjolUUJm6-LDG7h_KF138NbV_33wtS25ioQsN9/pub?gid=1893652539&single=true&output=csv' AS line

MATCH (p:product {product_id:line.Id}), (u:user {user_id:line.CreatedById})
CREATE (p)-[:CREATED_BY]->(u)