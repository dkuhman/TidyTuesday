#TidyTuesday 2020-05-05
#Author: Daniel Kuhman
#Github: https://github.com/dkuhman

library('tidyverse')
library('ggplot2')
library('ggpubr')

#Import Data:
critic <- readr::read_tsv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/critic.tsv')
user_reviews <- readr::read_tsv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/user_reviews.tsv')
items <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/items.csv')
villagers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-05/villagers.csv')

#Critic scores versus User Review scores
{
  user_reviews$grade<-user_reviews$grade*10
  user_reviews$review_type<-'User'
  critic$review_type<-'Critic'
  all_reviews<-rbind(user_reviews %>% select(review_type,grade),
                     critic %>% select(review_type,grade))
  all_reviews$review_type<-as.factor(all_reviews$review_type)
  
  #Boxplot of reviews
  p1<-ggplot(all_reviews, aes(x=review_type, y=grade))+
    geom_boxplot(aes(fill=review_type), color='black', lwd=1,
                 width=2, outlier.color='white')+
    geom_jitter(aes(group=review_type), size=0.3)+
    theme_classic()+
    xlab('Reviewer Type')+
    ylab('Grade') +
    coord_flip() +
    theme(
      axis.title.x = element_text(size = 18, color = 'black', face = 'bold',
                                  margin = margin(t=20, r=0, b=0, l=0)),
      axis.title.y = element_text(size = 18, color = 'black', face = 'bold',
                                  margin = margin(t=0, r=20, b=0, l=0)),
      axis.text = element_text(size = 12, colour = 'black', face = 'bold'),
      axis.line = element_line(color='black', size = 1.5),
      legend.position = 'none'
    )
  
  #Review distributions by group
  p2<-ggplot(all_reviews, aes(x=grade,fill=review_type))+
    geom_histogram(aes(y=..density..),alpha=0.5, color='black',
                   lwd=1, position = 'identity')+
    geom_density(color='black', lwd=0.2, alpha=0.2)+
    theme_classic()+
    xlab('Grade')+
    ylab('Density') +
    theme(
      axis.title.x = element_text(size = 18, color = 'black', face = 'bold',
                                  margin = margin(t=20, r=0, b=0, l=0)),
      axis.title.y = element_text(size = 18, color = 'black', face = 'bold',
                                  margin = margin(t=0, r=20, b=0, l=0)),
      axis.text = element_text(size = 12, colour = 'black', face = 'bold'),
      axis.line = element_line(color='black', size = 1.5),
      legend.position = 'none'
    )
  
  #Violin plot that shows distribution and group-level stats
  p3<-ggplot(all_reviews, aes(x=review_type, y=grade))+
    geom_violin(aes(fill=review_type), color='black', lwd=1,
                alpha=0.8)+
    theme_classic()+
    xlab('Reviewer Type')+
    ylab('Grade') +
    coord_flip() +
    theme(
      axis.title.x = element_text(size = 22, color = 'black', face = 'bold',
                                  margin = margin(t=20, r=0, b=0, l=0)),
      axis.title.y = element_text(size = 22, color = 'black', face = 'bold',
                                  margin = margin(t=0, r=20, b=0, l=0)),
      axis.text = element_text(size = 16, colour = 'black', face = 'bold'),
      axis.line = element_line(color='black', size = 1.5),
      legend.position = 'top',
      legend.title = element_text(size=0, color = 'white'),
      legend.text = element_text(size=14, face = 'bold', margin = margin(t=0, r=20, b=0, l=5))
    )
  
  #Group plots
  ggarrange(ggarrange(p1+rremove('x.title'), p2+rremove('x.title'),
                      ncol = 2),
            p3,             
            nrow = 2,
            heights = c(1,1.5)
  )
  
  rm(p1,p2,p3,all_reviews, legend.text)
}

#Distribution of moods in the game's villagers
{
  villagers$personality<-as.factor(villagers$personality)
  villagers$species<-as.factor(villagers$species)
  
  #Plot count of each mood
  #Colored by animal species
  ggplot(villagers, aes(x=personality, group=species))+
    geom_bar(aes(fill=species),alpha=0.8, color='black',lwd=1.75)+
    theme_classic()+
    xlab('Personality')+
    ylab('Count') +
    theme(
      axis.title.x = element_text(size = 25, color = 'black', face = 'bold',
                                  margin = margin(t=20, r=0, b=0, l=0)),
      axis.title.y = element_text(size = 25, color = 'black', face = 'bold',
                                  margin = margin(t=0, r=20, b=0, l=0)),
      axis.text = element_text(size = 16, colour = 'black'),
      axis.line = element_line(color='black', size = 1.5),
      legend.position = 'none'
    )
}
