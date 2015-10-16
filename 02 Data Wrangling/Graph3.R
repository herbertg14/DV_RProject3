df1 <- COD %>% select(STATE,YEAR,AADR,CAUSE_NAME) %>% filter(YEAR == 2009 & CAUSE_NAME == "Suicide")

df2 <- NHCE %>% filter(CODE == 7,COUNTRYGROUP == "State") %>% select(ITEM,STATE_NAME,Y2009) %>% rename(STATE = STATE_NAME, SPENDING = Y2009)

df <- dplyr::inner_join(df1,df2, by = "STATE")


ggplot() +
  coord_cartesian() +
  scale_x_continuous() + 
  scale_y_continuous() + 
  labs(title = "State spending vs. AADR") +
  labs(x= "Spending",y = "AADR") +
  layer(data = df,
        mapping = aes(x = SPENDING, y = AADR),
        stat="identity", 
        stat_params=list(),
        geom="point",geom_params=list(),
        position=position_jitter(width=0.3, height=0))
