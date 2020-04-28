# COVID-MDS
Building the Barts Health Master Data Set for COVID clinical trials and research. 

## Co-morbidities and Symptoms
SNOMED CT coded diagnoses are queried in Expression Constraint Language using Snowstorm for diagnoses of interest in Previous Medical History (PMH), COVID-related symptoms, and disease complications.   

SNOMED ConceptId's are mapped to DescriptionId's using SNOMED International's latest RF2 files (International concat with UK). Both Concept and Description Id's are saved as a CSV, for searching in Barts Health Data Warehouse. 
