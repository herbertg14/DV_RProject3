df1 <- COD %>% select(STATE,YEAR,DEATHS,AADR,CAUSE_NAME) %>% filter(YEAR == 1999 & CAUSE_NAME == "Cancer")

df2 <- NHCE %>% select(ITEM,STATE_NAME,Y1999,CODE,COUNTRYGROUP) %>% filter(CODE == 2,COUNTRYGROUP != "Region") %>% rename(STATE = STATE_NAME,SPENDING = Y1999)

df <- dplyr::full_join(df1,df2,by = "STATE")

df %>% ggplot(aes(x=reorder(STATE,SPENDING/DEATHS),y=SPENDING/DEATHS ,fill = STATE)) + geom_bar(stat = 'identity') + theme(legend.position = "none") + labs(title = "State Spending on Hospitals per Cancer Death",x= "STATE",y = "Dollars per Deaths") + theme(axis.text.x = element_text(angle = 45,size = 10))




