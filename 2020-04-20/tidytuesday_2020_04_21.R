#TidyTuesday
#Date: 2020-04-20
#Author: Daniel Kuhman
#Contact: danielkuhman@gmail.com

library("tidyverse")
library("ggplot2")
library('ggalluvial')

#Load data
gdpr_violations <- readr::read_tsv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-21/gdpr_violations.tsv')

gdpr_violations$name<-as.factor(gdpr_violations$name)
gdpr_violations$price<-as.numeric(gdpr_violations$price)

#Subset data
mydata<-gdpr_violations %>% select(name,type,price)

#Group by region
mydata$Region[mydata$name == 'Spain' |
                      mydata$name == 'Italy' |
                      mydata$name == 'Portugal' |
                      mydata$name == 'Greece' |
                      mydata$name == 'Malta' |
                      mydata$name == 'Cyprus'] <- 'South'

mydata$Region[mydata$name == 'France' |
                      mydata$name == 'Germany' |
                      mydata$name == 'Austria' |
                      mydata$name == 'Belgium' |
                      mydata$name == 'Netherlands' |
                      mydata$name == 'United Kingdom'] <- 'West'

mydata$Region[mydata$name == 'Slovakia' |
                      mydata$name == 'Latvia' |
                      mydata$name == 'Hungary' |
                      mydata$name == 'Lithuania' |
                      mydata$name == 'Czech Republic' |
                      mydata$name == 'Poland' |
                      mydata$name == 'Romania' |
                      mydata$name == 'Bulgaria' | 
                      mydata$name == 'Croatia'] <- 'Central'

mydata$Region[mydata$name == 'Sweden' |
                      mydata$name == 'Norway' |
                      mydata$name == 'Iceland' |
                      mydata$name == 'Denmark'] <- 'North'

#Categorize fine amount
mydata$cost_rng[mydata$price >= 0 & mydata$price < 100000]<-'0-100,000'
mydata$cost_rng[mydata$price >= 100000 & mydata$price <= 1000000]<-'100,001-1,000,000'
mydata$cost_rng[mydata$price > 1000000]<-'>1,000,000'

#Subset data for plotting
mydata<-mydata%>%select(Region,cost_rng)

#Get frequency
mydata<-mydata %>%
  group_by(Region, cost_rng) %>% 
  mutate(freq = n()) %>% 
  data.frame()

#Prepare data for plotting
mydata<-distinct(mydata)
mydata$cost_rng<-as.factor(mydata$cost_rng)
mydata$cost_rng <- factor(mydata$cost_rng, levels = c('>1,000,000', '100,001-1,000,000', '0-100,000'))

#Plot
ggplot(mydata, aes(axis1 = Region, axis2 = cost_rng, y = freq)) +
  scale_x_discrete(limits = c("Region", "Violation"), expand = c(.1, .05)) +
  xlab("Region & Violation Type") +
  ylab("Frequency") + 
  geom_alluvium(aes(fill = Region)) +
  geom_stratum() + geom_text(stat = "stratum", infer.label = TRUE) +
  theme_minimal() +
  ggtitle("Cost of General Data Protection Regulation (GDPR) Violations",
          "Stratified by European region and fine amount") +
  theme(
    plot.title = element_text(color="black", size=20, face="bold.italic", hjust = 0.5),
    axis.text = element_text(color = "black", size = 16),
    axis.title.x = element_text(color="black", size=18, margin = margin(t = 30, r = 0, b = 0, l = 0)),
    axis.title.y = element_text(color="black", size=18, margin = margin(t = 0, r = 30, b = 0, l = 0)),
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 18))


