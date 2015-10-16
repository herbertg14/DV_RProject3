df1 <- COD %>% select(STATE,YEAR,DEATHS,AADR,CAUSE_NAME) %>% filter(CAUSE_NAME == "All Causes", STATE == "Texas",YEAR >= 1999,YEAR <= 2009)

df2 <- NHCE %>% select(ITEM,STATE_NAME,CODE,COUNTRYGROUP,Y1999,Y2000,Y2001,Y2002,Y2003,Y2004,Y2005,Y2006,Y2007,Y2008,Y2009) %>% filter(STATE_NAME == "Texas",COUNTRYGROUP != "Region") %>% rename(STATE = STATE_NAME) %>% summarize(sum(Y1999),sum(Y2000),sum(Y2001),sum(Y2002),sum(Y2003),sum(Y2004),sum(Y2005),sum(Y2006),sum(Y2007),sum(Y2008),sum(Y2009)) %>% gather() %>% select(value) %>% mutate(YEAR = c(1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009)) %>% rename(Spending = value)

df <- dplyr::left_join(df1,df2,by='YEAR')

df %>% ggplot(aes(x = YEAR, y = Spending/DEATHS)) + geom_line(stat = "identity") + labs(x = "Year",y = "Healthcare Expenditure per Death",title = "Ratio of Texas Healthcare Expenditure(1000's of $) to Deaths")
