require(tidyr)
require(dplyr)
require(ggplot2)

setwd("/Users/Ryan_Wechter/DataVisualization/DV_RProject3")

file_path <- "US_AGGREGATE09.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)

# str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

dimensions <- c("Code","Item","Group","Region_Number","Region_Name","State_Name")



measures <- setdiff(names(df), dimensions)


sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
 
 

NHCE <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from NHCE"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_riw223', PASS='orcl_riw223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

COD <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from COD"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_riw223', PASS='orcl_riw223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

#Changes I made today
df1 <- COD %>% select(STATE,YEAR,DEATHS,AADR,CAUSE_NAME) %>% filter(YEAR == 1999 & CAUSE_NAME == "Cancer")

df2 <- NHCE %>% select(ITEM,STATE_NAME,Y1999,CODE,COUNTRYGROUP) %>% filter(CODE == 2,COUNTRYGROUP != "Region") %>% rename(STATE = STATE_NAME,SPENDING = Y1999)

NHCE %>% filter(COUNTRYGROUP != "Region") %>% rename(STATE = STATE_NAME,Y1999 = 1999) %>% dplyr::left_join(.,COD, by = "STATE") %>% View

df <- dplyr::left_join(df1,df2,by = "STATE")
  
ggplot() + coord_cartesian() + scale_x_discrete() + scale_y_continuous() + labs(title = "Cancer/Hospital Care",x= "STATE",y = "spending") + layer(data = df,mapping = aes(x = STATE,y = SPENDING/DEATHS), stat = "identity", geom = "bar")
