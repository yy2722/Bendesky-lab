##This script is for plotting the histogram distribution of the nearest wall distance during OF test (dark phase)
library(ggplot2)
library(ggpubr)
library(cowplot)
library(RColorBrewer)
library(ggrepel)
library(reshape2)

#set up work directory and read in all the data
setwd("/Volumes/FAT/Bendesky/Tracking/OF/results/analysis")

#distance to the nearest wall data
combined_nw <- read.table('20180722_nearest_wall_combined.txt', sep='\t', header = TRUE)
splitted_nw <- read.table('20180722_nearest_wall_splitted.txt', sep='\t', header = TRUE)

#change all the zeros to NA
combined_nw[combined_nw == 0] <- NA
splitted_nw[splitted_nw == 0] <- NA

#convert pixel into cm for distance to the nearest wall data
combined_nw <- combined_nw/3.25
splitted_nw <- splitted_nw/3.25

#separate the dark results and species
dark_only_nw <- combined_nw[, grep("dark_results", colnames(combined_nw))]
dark_BW<- dark_only_nw[, grep("BW", colnames(dark_only_nw))]
dark_PO<- dark_only_nw[, grep("PO", colnames(dark_only_nw))]

#separate all the hrs and species
splitted_nw_BW<- splitted_nw[, grep("BW", colnames(splitted_nw))]
splitted_nw_PO<- splitted_nw[, grep("PO", colnames(splitted_nw))]

dark1hr_nw_BW <- splitted_nw_BW[, grep("dark_1hr", colnames(splitted_nw_BW))]
dark2hr_nw_BW <- splitted_nw_BW[, grep("dark_2hr", colnames(splitted_nw_BW))]
dark3hr_nw_BW <- splitted_nw_BW[, grep("dark_3hr", colnames(splitted_nw_BW))]
dark4hr_nw_BW <- splitted_nw_BW[, grep("dark_4hr", colnames(splitted_nw_BW))]
dark5hr_nw_BW <- splitted_nw_BW[, grep("dark_5hr", colnames(splitted_nw_BW))]
dark6hr_nw_BW <- splitted_nw_BW[, grep("dark_6hr", colnames(splitted_nw_BW))]
dark7hr_nw_BW <- splitted_nw_BW[, grep("dark_7hr", colnames(splitted_nw_BW))]
dark8hr_nw_BW <- splitted_nw_BW[, grep("dark_8hr", colnames(splitted_nw_BW))]

dark1hr_nw_PO <- splitted_nw_PO[, grep("dark_1hr", colnames(splitted_nw_PO))]
dark2hr_nw_PO <- splitted_nw_PO[, grep("dark_2hr", colnames(splitted_nw_PO))]
dark3hr_nw_PO <- splitted_nw_PO[, grep("dark_3hr", colnames(splitted_nw_PO))]
dark4hr_nw_PO <- splitted_nw_PO[, grep("dark_4hr", colnames(splitted_nw_PO))]
dark5hr_nw_PO <- splitted_nw_PO[, grep("dark_5hr", colnames(splitted_nw_PO))]
dark6hr_nw_PO <- splitted_nw_PO[, grep("dark_6hr", colnames(splitted_nw_PO))]
dark7hr_nw_PO <- splitted_nw_PO[, grep("dark_7hr", colnames(splitted_nw_PO))]
dark8hr_nw_PO <- splitted_nw_PO[, grep("dark_8hr", colnames(splitted_nw_PO))]


bw <- melt(dark_BW)
po <- melt(dark_PO)

bw1hr <- melt(dark1hr_nw_BW)
po1hr <- melt(dark1hr_nw_PO)
bw2hr <- melt(dark2hr_nw_BW)
po2hr <- melt(dark2hr_nw_PO)
bw3hr <- melt(dark3hr_nw_BW)
po3hr <- melt(dark3hr_nw_PO)
bw4hr <- melt(dark4hr_nw_BW)
po4hr <- melt(dark4hr_nw_PO)
bw5hr <- melt(dark5hr_nw_BW)
po5hr <- melt(dark5hr_nw_PO)
bw6hr <- melt(dark6hr_nw_BW)
po6hr <- melt(dark6hr_nw_PO)
bw7hr <- melt(dark7hr_nw_BW)
po7hr <- melt(dark7hr_nw_PO)
bw8hr <- melt(dark8hr_nw_BW)
po8hr <- melt(dark8hr_nw_PO)

#get all mice histogram values
po_hist <- hist(po$value, breaks = 10, plot=F)
bw_hist <- hist(bw$value, breaks = 10, plot=F)
po1hr_hist <- hist(po1hr$value, breaks = 10, plot=F)
bw1hr_hist <- hist(bw1hr$value, breaks = 10, plot=F)
po2hr_hist <- hist(po2hr$value, breaks = 10, plot=F)
bw2hr_hist <- hist(bw2hr$value, breaks = 10, plot=F)
po3hr_hist <- hist(po3hr$value, breaks = 10, plot=F)
bw3hr_hist <- hist(bw3hr$value, breaks = 10, plot=F)
po4hr_hist <- hist(po4hr$value, breaks = 10, plot=F)
bw4hr_hist <- hist(bw4hr$value, breaks = 10, plot=F)
po5hr_hist <- hist(po5hr$value, breaks = 10, plot=F)
bw5hr_hist <- hist(bw5hr$value, breaks = 10, plot=F)
po6hr_hist <- hist(po6hr$value, breaks = 10, plot=F)
bw6hr_hist <- hist(bw6hr$value, breaks = 10, plot=F)
po7hr_hist <- hist(po7hr$value, breaks = 10, plot=F)
bw7hr_hist <- hist(bw7hr$value, breaks = 10, plot=F)
po8hr_hist <- hist(po8hr$value, breaks = 10, plot=F)
bw8hr_hist <- hist(bw8hr$value, breaks = 10, plot=F)

#histogram average
aver_hist_po <- po_hist$counts/16
aver_hist_bw <- bw_hist$counts/16
aver_hist_po1hr <- po1hr_hist$counts/16
aver_hist_bw1hr <- bw1hr_hist$counts/16
aver_hist_po2hr <- po2hr_hist$counts/16
aver_hist_bw2hr <- bw2hr_hist$counts/16
aver_hist_po3hr <- po3hr_hist$counts/16
aver_hist_bw3hr <- bw3hr_hist$counts/16
aver_hist_po4hr <- po4hr_hist$counts/16
aver_hist_bw4hr <- bw4hr_hist$counts/16
aver_hist_po5hr <- po5hr_hist$counts/16
aver_hist_bw5hr <- bw5hr_hist$counts/16
aver_hist_po6hr <- po6hr_hist$counts/16
aver_hist_bw6hr <- bw6hr_hist$counts/16
aver_hist_po7hr <- po7hr_hist$counts/16
aver_hist_bw7hr <- bw7hr_hist$counts/16
aver_hist_po8hr <- po8hr_hist$counts/16
aver_hist_bw8hr <- bw8hr_hist$counts/16

#make into a dataframe
bw_average <- as.data.frame(aver_hist_bw)
po_average <- as.data.frame(aver_hist_po)
bw1hr_average <- as.data.frame(aver_hist_bw1hr)
po1hr_average <- as.data.frame(aver_hist_po1hr)
bw2hr_average <- as.data.frame(aver_hist_bw2hr)
po2hr_average <- as.data.frame(aver_hist_po2hr)
bw3hr_average <- as.data.frame(aver_hist_bw3hr)
po3hr_average <- as.data.frame(aver_hist_po3hr)
bw4hr_average <- as.data.frame(aver_hist_bw4hr)
po4hr_average <- as.data.frame(aver_hist_po4hr)
bw5hr_average <- as.data.frame(aver_hist_bw5hr)
po5hr_average <- as.data.frame(aver_hist_po5hr)
bw6hr_average <- as.data.frame(aver_hist_bw6hr)
po6hr_average <- as.data.frame(aver_hist_po6hr)
bw7hr_average <- as.data.frame(aver_hist_bw7hr)
po7hr_average <- as.data.frame(aver_hist_po7hr)
bw8hr_average <- as.data.frame(aver_hist_bw8hr)
po8hr_average <- as.data.frame(aver_hist_po8hr)

bw_average[, 2] <- bw_hist$breaks[1:13]
po_average[, 2] <- po_hist$breaks[1:13]

bw2hr_average[13,] <-0
bw4hr_average[13,] <-0
bw5hr_average[13,] <-0
bw6hr_average[13,] <-0
bw7hr_average[13,] <-0
bw8hr_average[13,] <-0

bw1hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po1hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw2hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po2hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw3hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po3hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw4hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po4hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw5hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po5hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw6hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po6hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw7hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po7hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw8hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po8hr_average[, 2] <- bw1hr_hist$breaks[1:13]

#function to get hist count values
histval <- function(y){
  counter=1
  xx_df<-data.frame(matrix(0, ncol=16, nrow=13))
  for(x in y[,1:16]){
    hist_xx <-hist(x, breaks = 10, plot=F)
    if (length(hist_xx$counts)==12){
      vector_xx <- as.vector(hist_xx$counts)
      vector_xx[13]<- 0
      xx_df[,counter]<-vector_xx
      counter=counter+1
    }
    else if (length(hist_xx$counts)==11){
      vector_xx <- as.vector(hist_xx$counts)
      vector_xx[12:13]<- 0
      xx_df[,counter]<-vector_xx
      counter=counter+1
    }
    else{
      xx_df[,counter]<-hist_xx$counts
      counter=counter+1
    }
  }
  return(xx_df)
}

#get hist values for individual PO mice, y values full dark
po_df_melt <- melt(histval(dark_PO))
#get hist values for individual BW mice, y values full dark
bw_df_melt <- melt(histval(dark_BW))

d1hr_po_melt<- melt(histval(dark1hr_nw_PO))
d1hr_bw_melt<- melt(histval(dark1hr_nw_BW))
d2hr_po_melt<- melt(histval(dark2hr_nw_PO))
d2hr_bw_melt<- melt(histval(dark2hr_nw_BW))
d3hr_po_melt<- melt(histval(dark3hr_nw_PO))
d3hr_bw_melt<- melt(histval(dark3hr_nw_BW))
d4hr_po_melt<- melt(histval(dark4hr_nw_PO))
d4hr_bw_melt<- melt(histval(dark4hr_nw_BW))
d5hr_po_melt<- melt(histval(dark5hr_nw_PO))
d5hr_bw_melt<- melt(histval(dark5hr_nw_BW))
d6hr_po_melt<- melt(histval(dark6hr_nw_PO))
d6hr_bw_melt<- melt(histval(dark6hr_nw_BW))
d7hr_po_melt<- melt(histval(dark7hr_nw_PO))
d7hr_bw_melt<- melt(histval(dark7hr_nw_BW))
d8hr_po_melt<- melt(histval(dark8hr_nw_PO))
d8hr_bw_melt<- melt(histval(dark8hr_nw_BW))

#breaks for x values
breaks <-data.frame(matrix(0, ncol=16, nrow=13))
for(br in 1:16){
  breaks[, br]<- bw_hist$breaks[1:13]
}

#for the x axis values of all individual hist plotting
breaks <- melt(breaks)

#plot the data for indiviuals from each species and both average values
ggplot()+theme_dark()+geom_line(data=bw_df_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=po_df_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw_average, aes(x=bw_average$V2, y=bw_average$aver_hist_bw), color="red4")+geom_line(data=po_average, aes(x=po_average$V2, y=po_average$aver_hist_po), color ="blue")+ylab('log10(count)')+xlab('distance to the nearest wall')+scale_y_log10()+ggtitle('Dark phase (0-8hr)')
nw1<-ggplot()+theme_dark()+geom_line(data=d1hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d1hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw1hr_average, aes(x=bw1hr_average$V2, y=bw1hr_average$aver_hist_bw1hr), color="red4")+geom_line(data=po1hr_average, aes(x=po1hr_average$V2, y=po1hr_average$aver_hist_po1hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('0-1hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw2<-ggplot()+theme_dark()+geom_line(data=d2hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d2hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw2hr_average, aes(x=bw2hr_average$V2, y=bw2hr_average$aver_hist_bw2hr), color="red4")+geom_line(data=po2hr_average, aes(x=po2hr_average$V2, y=po2hr_average$aver_hist_po2hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('1-2hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw3<-ggplot()+theme_dark()+geom_line(data=d3hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d3hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw3hr_average, aes(x=bw3hr_average$V2, y=bw3hr_average$aver_hist_bw3hr), color="red4")+geom_line(data=po3hr_average, aes(x=po3hr_average$V2, y=po3hr_average$aver_hist_po3hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('2-3hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw4<-ggplot()+theme_dark()+geom_line(data=d4hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d4hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw4hr_average, aes(x=bw4hr_average$V2, y=bw4hr_average$aver_hist_bw4hr), color="red4")+geom_line(data=po4hr_average, aes(x=po4hr_average$V2, y=po4hr_average$aver_hist_po4hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('3-4hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw5<-ggplot()+theme_dark()+geom_line(data=d5hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d5hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw5hr_average, aes(x=bw5hr_average$V2, y=bw5hr_average$aver_hist_bw5hr), color="red4")+geom_line(data=po5hr_average, aes(x=po5hr_average$V2, y=po5hr_average$aver_hist_po5hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('4-5hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw6<-ggplot()+theme_dark()+geom_line(data=d6hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d6hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw6hr_average, aes(x=bw6hr_average$V2, y=bw6hr_average$aver_hist_bw6hr), color="red4")+geom_line(data=po6hr_average, aes(x=po6hr_average$V2, y=po6hr_average$aver_hist_po6hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('5-6hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw7<-ggplot()+theme_dark()+geom_line(data=d7hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d7hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw7hr_average, aes(x=bw7hr_average$V2, y=bw7hr_average$aver_hist_bw7hr), color="red4")+geom_line(data=po7hr_average, aes(x=po7hr_average$V2, y=po7hr_average$aver_hist_po7hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('6-7hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw8<-ggplot()+theme_dark()+geom_line(data=d8hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d8hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw8hr_average, aes(x=bw8hr_average$V2, y=bw8hr_average$aver_hist_bw8hr), color="red4")+geom_line(data=po8hr_average, aes(x=po8hr_average$V2, y=po8hr_average$aver_hist_po8hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1, 1e5))+ggtitle('7-8hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
plot_grid(nw1, nw2, nw3, nw4, ncol=4)
plot_grid(nw5, nw6, nw7, nw8, ncol=4)

histdensity <- function(y){
  counter=1
  xx_df<-data.frame(matrix(0, ncol=16, nrow=13))
  for(x in y[,1:16]){
    hist_xx <-hist(x, breaks = 10, plot=F)
    if (length(hist_xx$density)==12){
      vector_xx <- as.vector(hist_xx$density)
      vector_xx[13]<- 0
      xx_df[,counter]<-vector_xx
      counter=counter+1
    }
    else if (length(hist_xx$density)==11){
      vector_xx <- as.vector(hist_xx$density)
      vector_xx[12:13]<- 0
      xx_df[,counter]<-vector_xx
      counter=counter+1
    }
    else{
      xx_df[,counter]<-hist_xx$density
      counter=counter+1
    }
  }
  return(xx_df)
}

#histogram average
aver_hist_po <- po_hist$density
aver_hist_bw <- bw_hist$density
aver_hist_po1hr <- po1hr_hist$density
aver_hist_bw1hr <- bw1hr_hist$density
aver_hist_po2hr <- po2hr_hist$density
aver_hist_bw2hr <- bw2hr_hist$density
aver_hist_po3hr <- po3hr_hist$density
aver_hist_bw3hr <- bw3hr_hist$density
aver_hist_po4hr <- po4hr_hist$density
aver_hist_bw4hr <- bw4hr_hist$density
aver_hist_po5hr <- po5hr_hist$density
aver_hist_bw5hr <- bw5hr_hist$density
aver_hist_po6hr <- po6hr_hist$density
aver_hist_bw6hr <- bw6hr_hist$density
aver_hist_po7hr <- po7hr_hist$density
aver_hist_bw7hr <- bw7hr_hist$density
aver_hist_po8hr <- po8hr_hist$density
aver_hist_bw8hr <- bw8hr_hist$density

#make into a dataframe
bw_average <- as.data.frame(aver_hist_bw)
po_average <- as.data.frame(aver_hist_po)
bw1hr_average <- as.data.frame(aver_hist_bw1hr)
po1hr_average <- as.data.frame(aver_hist_po1hr)
bw2hr_average <- as.data.frame(aver_hist_bw2hr)
po2hr_average <- as.data.frame(aver_hist_po2hr)
bw3hr_average <- as.data.frame(aver_hist_bw3hr)
po3hr_average <- as.data.frame(aver_hist_po3hr)
bw4hr_average <- as.data.frame(aver_hist_bw4hr)
po4hr_average <- as.data.frame(aver_hist_po4hr)
bw5hr_average <- as.data.frame(aver_hist_bw5hr)
po5hr_average <- as.data.frame(aver_hist_po5hr)
bw6hr_average <- as.data.frame(aver_hist_bw6hr)
po6hr_average <- as.data.frame(aver_hist_po6hr)
bw7hr_average <- as.data.frame(aver_hist_bw7hr)
po7hr_average <- as.data.frame(aver_hist_po7hr)
bw8hr_average <- as.data.frame(aver_hist_bw8hr)
po8hr_average <- as.data.frame(aver_hist_po8hr)

bw_average[, 2] <- bw_hist$breaks[1:13]
po_average[, 2] <- po_hist$breaks[1:13]

bw2hr_average[13,] <-0
bw4hr_average[13,] <-0
bw5hr_average[13,] <-0
bw6hr_average[13,] <-0
bw7hr_average[13,] <-0
bw8hr_average[13,] <-0

bw1hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po1hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw2hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po2hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw3hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po3hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw4hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po4hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw5hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po5hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw6hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po6hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw7hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po7hr_average[, 2] <- bw1hr_hist$breaks[1:13]
bw8hr_average[, 2] <- bw1hr_hist$breaks[1:13]
po8hr_average[, 2] <- bw1hr_hist$breaks[1:13]

#get hist values for individual PO mice, y values full dark
po_df_melt <- melt(histdensity(dark_PO))
#get hist values for individual BW mice, y values full dark
bw_df_melt <- melt(histdensity(dark_BW))

d1hr_po_melt<- melt(histdensity(dark1hr_nw_PO))
d1hr_bw_melt<- melt(histdensity(dark1hr_nw_BW))
d2hr_po_melt<- melt(histdensity(dark2hr_nw_PO))
d2hr_bw_melt<- melt(histdensity(dark2hr_nw_BW))
d3hr_po_melt<- melt(histdensity(dark3hr_nw_PO))
d3hr_bw_melt<- melt(histdensity(dark3hr_nw_BW))
d4hr_po_melt<- melt(histdensity(dark4hr_nw_PO))
d4hr_bw_melt<- melt(histdensity(dark4hr_nw_BW))
d5hr_po_melt<- melt(histdensity(dark5hr_nw_PO))
d5hr_bw_melt<- melt(histdensity(dark5hr_nw_BW))
d6hr_po_melt<- melt(histdensity(dark6hr_nw_PO))
d6hr_bw_melt<- melt(histdensity(dark6hr_nw_BW))
d7hr_po_melt<- melt(histdensity(dark7hr_nw_PO))
d7hr_bw_melt<- melt(histdensity(dark7hr_nw_BW))
d8hr_po_melt<- melt(histdensity(dark8hr_nw_PO))
d8hr_bw_melt<- melt(histdensity(dark8hr_nw_BW))

ggplot()+theme_dark()+geom_line(data=bw_df_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=po_df_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw_average, aes(x=bw_average$V2, y=bw_average$aver_hist_bw), color="red4")+geom_line(data=po_average, aes(x=po_average$V2, y=po_average$aver_hist_po), color ="blue")+ylab('log10(relative frequency)')+xlab('distance to the nearest wall')+scale_y_log10()+ggtitle('Dark phase (0-8hr)')
nw1<-ggplot()+theme_dark()+geom_line(data=d1hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d1hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw1hr_average, aes(x=bw1hr_average$V2, y=bw1hr_average$aver_hist_bw1hr), color="red4")+geom_line(data=po1hr_average, aes(x=po1hr_average$V2, y=po1hr_average$aver_hist_po1hr), color ="blue")+ylab('log10(relative frequency)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('0-1hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw2<-ggplot()+theme_dark()+geom_line(data=d2hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d2hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw2hr_average, aes(x=bw2hr_average$V2, y=bw2hr_average$aver_hist_bw2hr), color="red4")+geom_line(data=po2hr_average, aes(x=po2hr_average$V2, y=po2hr_average$aver_hist_po2hr), color ="blue")+ylab('log10(relative frequency)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('1-2hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw3<-ggplot()+theme_dark()+geom_line(data=d3hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d3hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw3hr_average, aes(x=bw3hr_average$V2, y=bw3hr_average$aver_hist_bw3hr), color="red4")+geom_line(data=po3hr_average, aes(x=po3hr_average$V2, y=po3hr_average$aver_hist_po3hr), color ="blue")+ylab('log10(relative frequency)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('2-3hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw4<-ggplot()+theme_dark()+geom_line(data=d4hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d4hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw4hr_average, aes(x=bw4hr_average$V2, y=bw4hr_average$aver_hist_bw4hr), color="red4")+geom_line(data=po4hr_average, aes(x=po4hr_average$V2, y=po4hr_average$aver_hist_po4hr), color ="blue")+ylab('log10(relative frequency)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('3-4hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw5<-ggplot()+theme_dark()+geom_line(data=d5hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d5hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw5hr_average, aes(x=bw5hr_average$V2, y=bw5hr_average$aver_hist_bw5hr), color="red4")+geom_line(data=po5hr_average, aes(x=po5hr_average$V2, y=po5hr_average$aver_hist_po5hr), color ="blue")+ylab('log10(relative frequency)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('4-5hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw6<-ggplot()+theme_dark()+geom_line(data=d6hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d6hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw6hr_average, aes(x=bw6hr_average$V2, y=bw6hr_average$aver_hist_bw6hr), color="red4")+geom_line(data=po6hr_average, aes(x=po6hr_average$V2, y=po6hr_average$aver_hist_po6hr), color ="blue")+ylab('log10(relative frequency)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('5-6hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw7<-ggplot()+theme_dark()+geom_line(data=d7hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d7hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw7hr_average, aes(x=bw7hr_average$V2, y=bw7hr_average$aver_hist_bw7hr), color="red4")+geom_line(data=po7hr_average, aes(x=po7hr_average$V2, y=po7hr_average$aver_hist_po7hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('6-7hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
nw8<-ggplot()+theme_dark()+geom_line(data=d8hr_bw_melt, aes(y=value, x=breaks$value, group= variable), color='salmon')+geom_line(data=d8hr_po_melt, aes(y=value, x=breaks$value, group= variable), color='lightskyblue')+geom_line(data=bw8hr_average, aes(x=bw8hr_average$V2, y=bw8hr_average$aver_hist_bw8hr), color="red4")+geom_line(data=po8hr_average, aes(x=po8hr_average$V2, y=po8hr_average$aver_hist_po8hr), color ="blue")+ylab('log10(count)')+scale_y_log10(limits=c(1e-7, 1e-1))+ggtitle('7-8hr')+theme(axis.title.x= element_blank(), axis.title.y=element_blank())
plot_grid(nw1, nw2, nw3, nw4, ncol=4)
plot_grid(nw5, nw6, nw7, nw8, ncol=4)
