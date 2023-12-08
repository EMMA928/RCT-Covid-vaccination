#data.frame:1. Baseline survey data set
# Set seed for reproducibility
set.seed(123)

#sample size 
n<-5000

#simulate age from a normal distribution
age<-round(rnorm(n,mean=40,sd=10))

#simulate gender (binary variable)
gender<-rbinom(n,1,.5)

#simulate baseline measurements from a normal distribution
annual_salary<-rnorm(n,mean=59428,sd=8093)

#generate unique identifiers
unique_id<-paste0("id",sample(10000000:999999999,1))

#simulate location
location<-sample(c("Alabama","Alaska","Arizona"," Arkansas","California", "Colorado", "Connecticut", 
"Delaware","Florida","Georgia", "Hawaii","Idaho", "Illinois","Indiana","Iowa","Kansas","Kentucky", 
"Louisiana","Maine","Maryland","Massachusetts","Michigan", "Minnesota","Mississippi","Missouri",
"Montana","Nebraska","Nevada", "New Hampshire", "New Jersey", "New Mexico","New York","North Carolina", 
"North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina", "South Dakota", 
"Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"),size=n,replace=TRUE)

#simulate ethnicity
ethnicity<-sample(c("Black","White","Asian","Hispanic and Latino","Two or more races","Some other race","American Indian or Alaska Native","Native Hawaiian and other Pacific islander"),size=n,replace=TRUE)

#simulate religion
religion<-sample(c("protestantism","Catholicism","non-specific Christian","Mormonism","Judaism","other religions","unaffiliated with organized forms of religion","no answer"),size=n,replace=TRUE)

#simulate education levels
education<-sample(c("primary","middle","secondary","vocational","tertiary"),size=n,replace=TRUE)

#simulate marital status
marital<-sample(c("never married","married","separated","divorced","widowed"),size=n,replace=TRUE)

                
#simulate vaccination before the treatment is implemented
before<- rbinom(n, 1, 0.5)

#simulate the usage of Facebook
facebook_min<-rnorm(n,mean=35,sd=10)

# create a data frame to store the simulated baseline data
baseline<-data.frame(unique_id,age,gender,religion,ethnicity,education,marital,location,annual_salary,facebook_min,before)


#data.frame:2.random assignment
install.packages("tidyverse")

#create a variable treat that will be indicator for treatment and control
treat=sample(c("control","emotions","facts"),n,replace=TRUE,prob=c(.33,.33,.33))

#create a variable comply for whether person is "complier"
comply=sample(c(0,1),n,replace=TRUE,prob=c(.2,.8))

# create a data frame to store the simulated data and post=0 represents the treatment has not been done
random_assignment<-data.frame(unique_id,treat,comply,age,gender,location,post=0,before)

# check balance
library(dplyr)
random_assignment%>%
  group_by(treat) %>%
  summarize(ave_age=mean(age),
            ave_male=mean(gender=="0"))
library(ggplot2)

#hypothesis testing to see whether the differences between group means are significant
ggplot(random_assignment,
       aes(x=treat,y=age,
           color=treat))+
  stat_summary(geo="pointrange",
               fun.data="mean_se",
               fun.args=list(mult=1.96))+
  guides(color=FALSE)+
  labs(x=NULL,y="age")


                              
#data.frame:3.endline survey
library(dplyr)

#since only 4500 people complete the endline survey
random_assignment <- sample_n(random_assignment,4500)

#crete the endline dataset
endline<-random_assignment %>% mutate(post=1)

#merge two datasets
merged_datset<-rbind(random_assignment,endline)

#define a variable treat_effect that will be the simple treatment effects
merged_dataset<-merged_dataset%>% mutate(treat_effect=
              ifelse(post==1&treat=="facts" & comply==1, .7,              
              ifelse(post==1&treat=="emotions" & comply==1, .5,
              ifelse(post==1&treat=="facts" & comply==0, .3,
              ifelse(post==1&treat=="emotions"&comply==0, .4,
              ifelse(post==1&treat=="control" & comply==1,.0,
              ifelse(post==1&treat=="control" & comply==0, .6,NA)))))))

#define a variable that will show the vaccination outcomes after the RCT
merged_dataset<-merged_dataset%>% mutate(after=
            ifelse(post==1,df$before+df$treat_effect,
            ifelse(post==0,df$before,NA)))



#calculating the treatment effects of different approaches
regression_table<-summary(lm(after~treat,data=merged_dataset))

#visualizing the differences

ggplot(merged_dataset,
       aes(x=treat,
           y=after,
           color=treat))+
  stat_summary(geom="pointrange",
               fun.data="mean_se",
               fun.args=list(mult=1.96))+
  guides(color=FALSE)+
  labs(x=NULL,y="vaccination")
  
#eporting dataset
write.csv(baseline, "C:\\Users\\Xianglin li\\Desktop\\baseline.csv", row.names=FALSE)
write.csv(baseline, "C:\\Users\\Xianglin li\\Desktop\\random_assignment.csv", row.names=FALSE)
write.csv(baseline, "C:\\Users\\Xianglin li\\Desktop\\endline.csv", row.names=FALSE)
write.csv(baseline, "C:\\Users\\Xianglin li\\Desktop\\merged_dataset.csv", row.names=FALSE)

write.csv(regression_table, "tidy_lmfit.csv")


