df1 <- COD %>% select(STATE,YEAR,DEATHS,AADR,CAUSE_NAME) %>% filter(CAUSE_NAME == "All Causes", STATE == "Texas",YEAR >= 1999,YEAR <= 2009)

df2 <- NHCE %>% select(ITEM,STATE_NAME,CODE,COUNTRYGROUP,Y1999,Y2000,Y2001,Y2002,Y2003,Y2004,Y2005,Y2006,Y2007,Y2008,Y2009) %>% filter(STATE_NAME == "Texas",COUNTRYGROUP != "Region") %>% rename(STATE = STATE_NAME) %>% summarise_each(funs(mean))*11

df <- dplyr::right_join(df1,df2,by = "STATE")

