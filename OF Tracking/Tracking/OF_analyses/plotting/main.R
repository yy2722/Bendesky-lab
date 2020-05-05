##This is the script for creating the plots for the total distance travelled; proportion of time spent in differnt locations and EPM/OF correlations

#install.packages('ggplot2')
#install.packages('ggpubr')

library(ggplot2)
library(ggpubr)
library(cowplot)
library(RColorBrewer)
library(ggrepel)
library(reshape2)

#set up work directory and read in all the data
setwd("/Volumes/bendesky-locker/Tim/Tracking/OF/results/analysis")

#frequency data (combined for light before, after and dark; splitted for dark phase separeted hr by hr)
combined_data <- read.table('20180722_OF_data_combined.txt', sep='\t', header=TRUE)
splitted_data <- read.table('20180722_OF_data_splitted.txt', sep='\t', header=TRUE)

#total distance travelled data
combined_distance <- read.table('20180607_total_distance_combined.txt', sep='\t', header=FALSE)
splitted_distance <- read.table('20180615_total_distance_splitted.txt', sep='\t', header=FALSE)

#elevated plus maze frequency and total distance data from Natalie
epm_data <- read.table('EPM_full_data.txt', sep='\t', header=TRUE)

#combining all the values from very center, intermediate center, and intermediate to form a new column, Center, with new values
combined_data$Center <- combined_data$Very_center + combined_data$Intermediate_center + combined_data$Intermediate
splitted_data$Center <- splitted_data$Very_center + splitted_data$Intermediate_center + splitted_data$Intermediate

#combining all the values from very center, intermediate center, intermediate, near wall to from a new column, In_arena, with new values
combined_data$Arena <- combined_data$Very_center +combined_data$Intermediate_center + combined_data$Intermediate + combined_data$Near_wall
splitted_data$Arena <- splitted_data$Very_center +splitted_data$Intermediate_center + splitted_data$Intermediate + splitted_data$Near_wall

#make the elements in the ID column as factors instead of continuous numbers
splitted_data$ID <- as.factor(splitted_data$ID)
combined_data$ID <- as.factor(combined_data$ID)
splitted_distance$V4 <- as.factor(splitted_distance$V4)
combined_distance$V4 <- as.factor(combined_distance$V4)

epm_data$ID <- as.factor(epm_data$ID)

#order all the data sets by ID so the IDs are in the same order when combining with the data from total distance travelled
combined_data <- combined_data[order(combined_data$Date, combined_data$Segment),]
splitted_data <- splitted_data[order(splitted_data$Date, splitted_data$Segment),]
combined_distance <- combined_distance[order(combined_distance$V1, combined_distance$V5),]
splitted_distance <- splitted_distance[order(splitted_distance$V1, splitted_distance$V5),]

#take the distance column in total distance data and create a new column in data
combined_data$Distance <- combined_distance$V6
splitted_data$Distance <- splitted_distance$V6

#convert cm to km
combined_data$Distance <- combined_data$Distance/100000
splitted_data$Distance <- splitted_data$Distance/100000


#organize the data into only full 8 hr dark phase, light before dark, light after dark, and eight 1 hr segments of dark
full_dark <- combined_data[combined_data$Segment == "dark_results",]
light_before <- combined_data[combined_data$Segment == "light_before",]
light_after <- combined_data[combined_data$Segment == "light_after",]
dark1hr <- splitted_data[splitted_data$Segment == "dark_1hr",]
dark2hr <- splitted_data[splitted_data$Segment == "dark_2hr",]
dark3hr <- splitted_data[splitted_data$Segment == "dark_3hr",]
dark4hr <- splitted_data[splitted_data$Segment == "dark_4hr",]
dark5hr <- splitted_data[splitted_data$Segment == "dark_5hr",]
dark6hr <- splitted_data[splitted_data$Segment == "dark_6hr",]
dark7hr <- splitted_data[splitted_data$Segment == "dark_7hr",]
dark8hr <- splitted_data[splitted_data$Segment == "dark_8hr",]

#get the IDs that are in both OF and EPM data
common_mice <- intersect(full_dark$ID, epm_data$ID)

#get the mice that have been tested in both tests, IDs overlapping in both data sets 
epm_common <- epm_data[epm_data$ID %in% common_mice, ]
OF_common <- full_dark[full_dark$ID %in% common_mice,]

#remove the repeated entry BW 289 from the dataframe of epm
epm_common <- epm_common[-5,]

#sort all the dataframe based on ID
epm_common <- epm_common[order(epm_common$ID),]
OF_common <- OF_common[order(OF_common$ID),]

#take the columns from epm dataframe and add to OF dataframe
OF_common$epm_open <- epm_common$Open
OF_common$epm_closed <- epm_common$Closed
OF_common$epm_distance <- epm_common$Total_distance

#rename OF_common dataframe
epm_OF_combined <- OF_common

#Set limits for x and y axes
limy<-ylim(0,1)
limx<-xlim(0,1)

#boxplot+jitterplot for full dark (center; near wall; homecage)
a<-ggplot(data=full_dark, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =0.95, color='white')+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW", color='white')+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('In center')
b<-ggplot(data=full_dark, aes(x=Strain, y=Near_wall, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.95, color='white')+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW", color='white')+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('Near wall')
c<-ggplot(data=full_dark, aes(x=Strain, y=Home_cage, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.95, color='white')+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW", color='white')+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('Homecage')

plot_grid(a,b,c, ncol=3)

#boxplot+jitterplot for light before dark (center; near wall; homecage)
d<-ggplot(data=light_before, aes(x=Strain, y=Center, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.5)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('In center')
e<-ggplot(data=light_before, aes(x=Strain, y=Near_wall, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.5)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('Near wall')
f<-ggplot(data=light_before, aes(x=Strain, y=Home_cage, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.5)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('Homecage')

plot_grid(d, e, f, ncol=3)

#boxplot+jitterplot for light after dark (center; near wall; homecage)
g<-ggplot(data=light_after, aes(x=Strain, y=Center, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.5)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW", label.y=0.8)+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('In center')
h<-ggplot(data=light_after, aes(x=Strain, y=Near_wall, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.5)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW", label.y=0.8)+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('Near wall')
i<-ggplot(data=light_after, aes(x=Strain, y=Home_cage, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.5)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW", label.y=0.8)+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time')+theme(legend.position="none")+ggtitle('Homecage')

plot_grid(g, h, i, ncol=3)

#remove legends and y axis title
remove <- theme(legend.position="none", axis.title.y=element_blank())

#proportion of time spent in center hr by hr
s1 <- ggplot(data=light_before, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('-1 to 0 hr')+theme(legend.position="none",axis.title.y=element_blank())
s2 <- ggplot(data=dark1hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+xlab('0 to 1 hr')+remove
s3 <- ggplot(data=dark2hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('1 to 2 hr ')+remove
s4 <- ggplot(data=dark3hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('2 to 3 hr')+remove
s5 <- ggplot(data=dark4hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('3 to 4 hr')+remove
s6 <- ggplot(data=dark5hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('4 to 5 hr')+remove
s7 <- ggplot(data=dark6hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('5 to 6 hr')+remove
s8 <- ggplot(data=dark7hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('6 to 7 hr')+remove
s9 <- ggplot(data=dark8hr, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('7 to 8 hr')+remove
s10 <- ggplot(data=light_after, aes(x=Strain, y=Center, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('8 to 9 hr')+remove
plot_grid(s1,s2,s3,s4,s5, ncol=5)
plot_grid(s6,s7,s8,s9,s10, ncol=5)

#proportion of time spent near wall hr by hr
s1 <- ggplot(data=light_before, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('-1 to 0 hr')+theme(legend.position="none",axis.title.y=element_blank())
s2 <- ggplot(data=dark1hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+xlab('0 to 1 hr')+remove
s3 <- ggplot(data=dark2hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('1 to 2 hr ')+remove
s4 <- ggplot(data=dark3hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('2 to 3 hr')+remove
s5 <- ggplot(data=dark4hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('3 to 4 hr')+remove
s6 <- ggplot(data=dark5hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('4 to 5 hr')+remove
s7 <- ggplot(data=dark6hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('5 to 6 hr')+remove
s8 <- ggplot(data=dark7hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('6 to 7 hr')+remove
s9 <- ggplot(data=dark8hr, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('7 to 8 hr')+remove
s10 <- ggplot(data=light_after, aes(x=Strain, y=Near_wall, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('8 to 9 hr')+remove
plot_grid(s1,s2,s3,s4,s5, ncol=5)
plot_grid(s6,s7,s8,s9,s10, ncol=5)

#proportion of time spent in homecage hr by hr
s1 <- ggplot(data=light_before, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('-1 to 0 hr')+theme(legend.position="none",axis.title.y=element_blank())
s2 <- ggplot(data=dark1hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+xlab('0 to 1 hr')+remove
s3 <- ggplot(data=dark2hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('1 to 2 hr ')+remove
s4 <- ggplot(data=dark3hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('2 to 3 hr')+remove
s5 <- ggplot(data=dark4hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('3 to 4 hr')+remove
s6 <- ggplot(data=dark5hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('4 to 5 hr')+remove
s7 <- ggplot(data=dark6hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('5 to 6 hr')+remove
s8 <- ggplot(data=dark7hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('6 to 7 hr')+remove
s9 <- ggplot(data=dark8hr, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('7 to 8 hr')+remove
s10 <- ggplot(data=light_after, aes(x=Strain, y=Home_cage, fill= Strain))+stat_compare_means(method = 't.test', label.y =0)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1)+ylab('Total distance travelled in km')+xlab('8 to 9 hr')+remove
plot_grid(s1,s2,s3,s4,s5, ncol=5)
plot_grid(s6,s7,s8,s9,s10, ncol=5)

#boxplot+jitterplot for time inside the arena (between species)
j<-ggplot(data=light_before, aes(x=Strain, y=Arena, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('-1 hr to 0 hr')+theme(legend.position="none")+ggtitle('1hr before')
k<-ggplot(data=full_dark, aes(x=Strain, y=Arena, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.25)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('0 hr to 8 hr')+theme(legend.position="none")+ggtitle('Dark phase')
l<-ggplot(data=light_after, aes(x=Strain, y=Arena, fill=Strain))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('8 hr to 9 hr')+theme(legend.position="none")+ggtitle('1hr after')
plot_grid(j, k, l, ncol=3)

#Compare male and female within species during full dark (center; near wall; homecage)
BW_light_after <- light_after[light_after$Strain == "BW",]
PO_light_after <- light_after[light_after$Strain == "PO",]
BW_full_dark <- full_dark[full_dark$Strain == "BW",]
PO_full_dark <- full_dark[full_dark$Strain == "PO",]
BW_light_before <- light_before[light_before$Strain == "BW",]
PO_light_before <- light_before[light_before$Strain == "PO",]

#proportion of time spent in different locations (full_dark) M vs F
f1<-ggplot(data=BW_full_dark, aes(x=Sex, y=Center, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in center')+theme(legend.position="none")+ggtitle("BW")
f2<-ggplot(data=BW_full_dark, aes(x=Sex, y=Near_wall, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time near wall')+theme(legend.position="none")+ggtitle("BW")
f3<-ggplot(data=BW_full_dark, aes(x=Sex, y=Home_cage, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in homecage')+theme(legend.position="none")+ggtitle("BW")
plot_grid(f1, f2, f3, ncol=3)

p1<-ggplot(data=PO_full_dark, aes(x=Sex, y=Center, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in center')+theme(legend.position="none")+ggtitle("PO")
p2<-ggplot(data=PO_full_dark, aes(x=Sex, y=Near_wall, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time near wall')+theme(legend.position="none")+ggtitle("PO")
p3<-ggplot(data=PO_full_dark, aes(x=Sex, y=Home_cage, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in homecage')+theme(legend.position="none")+ggtitle("PO")
plot_grid(p1, p2, p3, ncol=3)

#BW M vs F inside arena
ff1<-ggplot(data=BW_light_before, aes(x=Sex, y=Arena, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('-1 hr to 0 hr')+theme(legend.position="none")+ggtitle('1hr before',subtitle = "BW")
ff2<-ggplot(data=BW_full_dark, aes(x=Sex, y=Arena, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.25)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('0 hr to 8 hr')+theme(legend.position="none")+ggtitle('Dark phase',subtitle = "BW")
ff3<-ggplot(data=BW_light_after, aes(x=Sex, y=Arena, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('8 hr to 9 hr')+theme(legend.position="none")+ggtitle('1hr after',subtitle = "BW")
plot_grid(ff1, ff2, ff3, ncol=3)

#PO M vs F inside arena
pp1<-ggplot(data=PO_light_before, aes(x=Sex, y=Arena, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('-1 hr to 0 hr')+theme(legend.position="none")+ggtitle('1hr before',subtitle = "PO")
pp2<-ggplot(data=PO_full_dark, aes(x=Sex, y=Arena, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.25)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('0 hr to 8 hr')+theme(legend.position="none")+ggtitle('Dark phase',subtitle = "PO")
pp3<-ggplot(data=PO_light_after, aes(x=Sex, y=Arena, fill=Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+limy+ylab('Proportion of time in arena')+xlab('8 hr to 9 hr')+theme(legend.position="none")+ggtitle('1hr after',subtitle = "PO")
plot_grid(pp1, pp2, pp3, ncol=3)

#BW M vs F total distance travelled
aa1 <- ggplot(data=BW_light_before, aes(x=Sex, y=Distance, fill= Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.5)+ylab('Total distance travelled in km')+xlab('-1 to 0 hr')+theme(legend.position="none")+ggtitle('1hr before',subtitle = "BW")
aa2 <- ggplot(data=BW_full_dark, aes(x=Sex, y=Distance, fill= Sex))+stat_compare_means(method = 't.test', label.y =6)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,10)+ylab('Total distance travelled in km')+xlab('0 to 8 hr')+theme(legend.position="none")+ggtitle('Dark phase',subtitle = "BW")
aa3 <- ggplot(data=BW_light_after, aes(x=Sex, y=Distance, fill= Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.5)+ylab('Total distance travelled in cmkm')+xlab('8 to 9 hr')+theme(legend.position="none")+ggtitle('1hr after',subtitle = "BW")
plot_grid(aa1, aa2, aa3, ncol=3)

#PO M vs F total distance travelled
mm1 <- ggplot(data=PO_light_before, aes(x=Sex, y=Distance, fill= Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.5)+ylab('Total distance travelled in km')+xlab('-1 to 0 hr')+theme(legend.position="none")+ggtitle('1hr before',subtitle = "PO")
mm2 <- ggplot(data=PO_full_dark, aes(x=Sex, y=Distance, fill= Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,10)+ylab('Total distance travelled in km')+xlab('0 to 8 hr')+theme(legend.position="none")+ggtitle('Dark phase',subtitle = "PO")
mm3 <- ggplot(data=PO_light_after, aes(x=Sex, y=Distance, fill= Sex))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "F")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.5)+ylab('Total distance travelled in cmkm')+xlab('8 to 9 hr')+theme(legend.position="none")+ggtitle('1hr after',subtitle = "PO")
plot_grid(mm1, mm2, mm3, ncol=3)

#total distance travelled all time periods
d1 <- ggplot(data=light_before, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,5)+ylab('Total distance travelled in km')+xlab('-1 to 0 hr')+theme(legend.position="none")+ggtitle('1hr before')
d2 <- ggplot(data=full_dark, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,10)+ylab('Total distance travelled in km')+xlab('0 to 8 hr')+theme(legend.position="none")+ggtitle('Dark phase')
d3 <- ggplot(data=light_after, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =0.95)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,5)+ylab('Total distance travelled in cmkm')+xlab('8 to 9 hr')+theme(legend.position="none")+ggtitle('1hr after')
plot_grid(d1, d2, d3, ncol=3)

#total distance travelled hr by hr
s1 <- ggplot(data=light_before, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('-1 to 0 hr')+theme(legend.position="none",axis.title.y=element_blank())
s2 <- ggplot(data=dark1hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+xlab('0 to 1 hr')+remove
s3 <- ggplot(data=dark2hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('1 to 2 hr ')+remove
s4 <- ggplot(data=dark3hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('2 to 3 hr')+remove
s5 <- ggplot(data=dark4hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('3 to 4 hr')+remove
s6 <- ggplot(data=dark5hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('4 to 5 hr')+remove
s7 <- ggplot(data=dark6hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('5 to 6 hr')+remove
s8 <- ggplot(data=dark7hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('6 to 7 hr')+remove
s9 <- ggplot(data=dark8hr, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =2)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_dark()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('7 to 8 hr')+remove
s10 <- ggplot(data=light_after, aes(x=Strain, y=Distance, fill= Strain))+stat_compare_means(method = 't.test', label.y =0)+stat_compare_means(label = 'p.signif', method ='t.test', ref.group = "BW")+theme_classic()+geom_boxplot()+geom_jitter(position = position_jitter(0.2))+ylim(0,1.2)+ylab('Total distance travelled in km')+xlab('8 to 9 hr')+remove
plot_grid(s1,s2,s3,s4,s5, ncol=5)
plot_grid(s6,s7,s8,s9,s10, ncol=5)

#correlations between OF and EPM data(open vs center; closed vs near wall; closed vs homecage)
BW_points_open <- geom_point(data=epm_OF_combined[which(epm_OF_combined$Strain == 'BW'), ], aes(x=epm_open, y=Center), colour= 'salmon')
PO_points_open <- geom_point(data=epm_OF_combined[which(epm_OF_combined$Strain == 'PO'), ], aes(x=epm_open, y=Center), colour= 'lightskyblue')
BW_points_closed <- geom_point(data=epm_OF_combined[which(epm_OF_combined$Strain == 'BW'), ], aes(x=epm_closed, y=Near_wall), colour= 'salmon')
PO_points_closed <- geom_point(data=epm_OF_combined[which(epm_OF_combined$Strain == 'PO'), ], aes(x=epm_closed, y=Near_wall), colour= 'lightskyblue')
BW_points_homecage <- geom_point(data=epm_OF_combined[which(epm_OF_combined$Strain == 'BW'), ], aes(x=epm_closed, y=Home_cage), colour= 'salmon')
PO_points_homecage <- geom_point(data=epm_OF_combined[which(epm_OF_combined$Strain == 'PO'), ], aes(x=epm_closed, y=Home_cage), colour= 'lightskyblue')
cor_coefficient <- stat_cor(method = 'pearson', label.x = 0.5, label.y = 0.6)
linear_reg <- geom_smooth(method=lm, fullrange=TRUE, se=TRUE, level=0.95)

#BW EPM/OF correlations
a1 <- ggplot(epm_OF_combined[which(epm_OF_combined$Strain == 'BW'), ], aes(x=epm_open, y=Center))+theme_classic()+xlim(0,0.5)+ylim(0,0.3)+BW_points_open+stat_cor(method = 'pearson', label.x = 0.2, label.y = 0.2)+linear_reg+ggtitle('BW')+ylab('proportion of time in center')+xlab('proportion of time in open arms')
a2 <- ggplot(epm_OF_combined[which(epm_OF_combined$Strain == 'BW'), ], aes(x=epm_closed, y=Near_wall))+theme_classic()+limx+limy+BW_points_closed+cor_coefficient+linear_reg+ggtitle('BW')+ylab('proportion of time near wall')+xlab('proportion of time in closed arms')
a3 <- ggplot(epm_OF_combined[which(epm_OF_combined$Strain == 'BW'), ], aes(x=epm_closed, y=Home_cage))+theme_classic()+limx+ylim(0,0.75)+BW_points_homecage+cor_coefficient+linear_reg+ggtitle('BW')+ylab('proportion of time in homecage')+xlab('proportion of time in closed arms')
#PO EPM/OF correlations
b2 <- ggplot(epm_OF_combined[which(epm_OF_combined$Strain == 'PO'), ], aes(x=epm_closed, y=Near_wall))+theme_classic()+limx+limy+PO_points_closed+cor_coefficient+linear_reg+ggtitle('PO')+ylab('proportion of time near wall')+xlab('proportion of time in closed arms')
b1 <- ggplot(epm_OF_combined[which(epm_OF_combined$Strain == 'PO'), ], aes(x=epm_open, y=Center))+theme_classic()+xlim(0,0.5)+ylim(0,0.3)+PO_points_open+stat_cor(method = 'pearson', label.x = 0.2, label.y = 0.2)+linear_reg+ggtitle('PO')+ylab('proportion of time in center')+xlab('proportion of time in open arms')
b3 <- ggplot(epm_OF_combined[which(epm_OF_combined$Strain == 'PO'), ], aes(x=epm_closed, y=Home_cage))+theme_classic()+limx+ylim(0,0.75)+PO_points_homecage+cor_coefficient+linear_reg+ggtitle('PO')+ylab('proportion of time in homecage')+xlab('proportion of time in closed arms')

plot_grid(a1,b1,ncol=2)
plot_grid(a2,b2,ncol=2)
plot_grid(a3,b3,ncol=2)
