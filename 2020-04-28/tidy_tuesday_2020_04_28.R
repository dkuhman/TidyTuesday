#TidyTuesday 2020-04-28
#Author: Daniel Kuhman
#Contact: danielkuhman@gmail.com

library('tidyverse')
library('ggplot2')
library('stargazer')

#Import Data:
grosses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-28/grosses.csv')

#DATA PREP
#Total performances
grosses<-grosses %>% 
  mutate(total_peformances = performances + previews)

#Estimate potential weekly gross for those with NAs
grosses$potential_gross[is.na(grosses$potential_gross)]<-grosses$total_peformances * grosses$seats_in_theatre * grosses$avg_ticket_price

#Average ticket price over time
#Weekly Box Office Gross Across Years for all shows
ggplot(grosses, aes(x=year, y=weekly_gross, group=year))+
  geom_boxplot(lwd=1, outlier.color = 'white')+
  geom_jitter(aes(color=show))+
  theme_classic()+
  xlab('Year')+
  ylab('Weekly Box Office Gross')+
  theme(
    legend.position = 'none',
    axis.title.x = element_text(size = 20,face = 'bold',
                              margin = margin(t=10,r=0,b=0,l=0)),
    axis.title.y = element_text(size = 20, face = 'bold',
                                margin = margin(t=0,r=10,b=0,l=0)),
    axis.line = element_line(color='black', size = 1.5),
    axis.text = element_text(size = 10,color = 'black')
  )

#Data distributions per year
grosses$show<-as.factor(grosses$show)
grosses_means<-grosses %>% select(show,weekly_gross,year)
grosses_means<-aggregate(weekly_gross ~ show + year, grosses_means, mean, na.rm=FALSE)
  
ggplot(grosses, aes(x = weekly_gross)) +
  geom_histogram(aes(y=..density..),
                 fill='white', color='black', lwd=1) +
  geom_density(fill='blue', alpha=0.2)+
  facet_wrap(~year)+
  theme_classic()+
  xlab('Weekly Box Office Gross ($)')+
  ylab('Density')+
  theme(
    legend.position = 'none',
    axis.title.x = element_text(size = 20,face = 'bold',
                                margin = margin(t=10,r=0,b=0,l=0)),
    axis.title.y = element_text(size = 20, face = 'bold',
                                margin = margin(t=0,r=10,b=0,l=0)),
    axis.line = element_line(color='black'),
    axis.text = element_text(size = 8,color = 'black')
  )

#TABLE OF TOP SHOWS EACH YEAR
#Top Box Office earners each year
grosses_sums<-grosses %>% select(show,weekly_gross,year)
grosses_sums<-aggregate(weekly_gross ~ show + year, grosses_sums, sum, na.rm=FALSE)
grosses_max_year<-grosses_sums %>% 
  group_by(year) %>% 
  mutate(rank = rank(-weekly_gross, ties.method = 'first'))
grosses_max_year<-grosses_max_year %>% 
  filter(rank==1) %>% 
  select(year,show,weekly_gross)
grosses_max_year$show<-as.character(grosses_max_year$show)
grosses_max_year$year<-as.character(grosses_max_year$year)

#Generate LaTex code for the table
stargazer(grosses_max_year, summary = FALSE, title = 'Highest Box Office Shows Each Year')


