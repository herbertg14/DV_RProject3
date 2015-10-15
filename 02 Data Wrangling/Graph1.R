df1 <- COD %>% select(STATE,YEAR,DEATHS,AADR,CAUSE_NAME) %>% filter(YEAR == 1999 & CAUSE_NAME == "Cancer")

df2 <- NHCE %>% select(ITEM,STATE_NAME,Y1999,CODE,COUNTRYGROUP) %>% filter(CODE == 2,COUNTRYGROUP != "Region") %>% rename(STATE = STATE_NAME,SPENDING = Y1999)

NHCE %>% filter(COUNTRYGROUP != "Region") %>% rename(STATE = STATE_NAME, Y1999 = 1999) %>% dplyr::left_join(.,COD, by = "STATE") %>% View

df <- dplyr::left_join(df1,df2,by = "STATE")

df %>% ggplot(aes(x=reorder(STATE,SPENDING/DEATHS),y=SPENDING/DEATHS ,fill = STATE)) + geom_bar(stat = 'identity') + theme(legend.position = "none")



ggplot() +  coord_cartesian() + scale_x_discrete() + scale_y_continuous() + labs(title = "Cancer/Hospital Care",x= "STATE",y = "spending") + layer(data = df,mapping = aes(x = STATE,y = SPENDING/DEATHS), stat = "identity", geom = "bar")
