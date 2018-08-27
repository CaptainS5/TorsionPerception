library(utils)
library(ggplot2)

## clear environment
rm(list=ls())

## load data
setwd("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/analysis")
conData1Original <- read.csv('conDataAllExp1.csv')
conData2Original <- read.csv('conDataAllExp2BothEyes.csv')
# eye: 1 left eye, 2 right eye
# afterReversalD: -1 CCW, 1 CW, 0 merged as CW
# time window: -1 120ms after onset to flash onset; 0-flash onset to flash offset; 1 120ms after flash offset to end

## summary plot for all participants
# perceptual illusion, two experiments together
# prepare data
conData1 <- conData1Original[which(conData1Original$afterReversalD==0 & conData1Original$timeWindow==1), ]
conData2 <- conData2Original[which(conData2Original$afterReversalD==0 & conData2Original$timeWindow==1), ]

sub <- rbind(conData1["sub"], conData2["sub"], deparse.level = 1)
exp <- rbind(conData1["exp"], conData2["exp"], deparse.level = 1)
rotationSpeed <- rbind(conData1["rotationSpeed"], conData2["rotationSpeed"], deparse.level = 1)
perceptualErrorMean <- rbind(conData1["perceptualErrorMean"], conData2["perceptualErrorMean"], deparse.level = 1)
torsionVelTMean <- rbind(conData1["torsionVelTMean"], conData2["torsionVelTMean"], deparse.level = 1)
dataAll <- data.frame(sub, exp, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataAll$exp <- as.factor(dataAll$exp)
dataAll$rotationSpeed <- as.factor(dataAll$rotationSpeed)

#pdf('perceptualErrorExp1&2.pdf')
ggplot(dataAll, aes(x=rotationSpeed, y=perceptualErrorMean, fill=exp)) + 
  geom_bar(position = "dodge", stat = "summary", fun.y = "mean", alpha = 0.7) + 
  stat_summary(fun.data = mean_se, geom = "errorbar", width=0.2, position = position_dodge(1)) +
  geom_point(aes(fill=exp), shape = 21, size = 2.5, position = position_jitterdodge(), alpha = 0.7) + 
  scale_fill_brewer(palette="Set1") +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) 
#dev.off()

# torsion velocity, two experiments together
# pdf('perceptualErrorExp1&2.pdf')
# ggplot(dataAll, aes(x=rotationSpeed, y=perceptualErrorMean, fill=exp)) + 
#   geom_boxplot(outlier.shape = NA, alpha = 0.7) + 
#   geom_point(aes(fill=exp), shape = 21, size = 2.5, position = position_jitterdodge()) + 
#   theme(axis.line = element_line(colour = "black"),
#         panel.grid.major = element_blank(),
#         panel.grid.minor = element_blank(),
#         panel.border = element_blank(),
#         panel.background = element_blank()) 
# dev.off()