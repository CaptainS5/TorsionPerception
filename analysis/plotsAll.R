library(utils)
library(ggplot2)
library(dplyr)
library(ppcor)

## clear environment
rm(list = ls())

## load data
setwd("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/analysis")
# conData1Original <- read.csv('conDataAllExp1.csv')
# conData2Original <- read.csv('conDataAllExp2BothEyes.csv')
# # eye: 1 left eye, 2 right eye
# # afterReversalD: -1 CCW, 1 CW, 0 merged as CW
# # time window: -1 120ms after onset to flash onset; 0-flash onset to flash offset; 1 120ms after flash offset to end
#
# ## summary plot for all participants
# # perceptual illusion, two experiments together
# # prepare data
# conData1 <- conData1Original[which(conData1Original$afterReversalD==0 & conData1Original$timeWindow==1), ]
# conData2 <- conData2Original[which(conData2Original$afterReversalD==0 & conData2Original$timeWindow==1), ]
#
# sub <- rbind(conData1["sub"], conData2["sub"], deparse.level = 1)
# exp <- rbind(conData1["exp"], conData2["exp"], deparse.level = 1)
# rotationSpeed <- rbind(conData1["rotationSpeed"], conData2["rotationSpeed"], deparse.level = 1)
# perceptualErrorMean <- rbind(conData1["perceptualErrorMean"], conData2["perceptualErrorMean"], deparse.level = 1)
# torsionVelTMean <- rbind(conData1["torsionVelTMean"], conData2["torsionVelTMean"], deparse.level = 1)
# dataAll <- data.frame(sub, exp, rotationSpeed, perceptualErrorMean, torsionVelTMean)
# dataAll$exp <- as.factor(dataAll$exp)
# dataAll$rotationSpeed <- as.factor(dataAll$rotationSpeed)
#
# #pdf('perceptualErrorExp1&2.pdf')
# ggplot(dataAll, aes(x=rotationSpeed, y=perceptualErrorMean, fill=exp)) +
#   geom_bar(position = "dodge", stat = "summary", fun.y = "mean", alpha = 0.7) +
#   stat_summary(fun.data = mean_se, geom = "errorbar", width=0.2, position = position_dodge(1)) +
#   geom_point(aes(fill=exp), shape = 21, size = 2.5, position = position_jitterdodge(), alpha = 0.7) +
#   scale_fill_brewer(palette="Set1") +
#   theme(axis.line = element_line(colour = "black"),
#         panel.grid.major = element_blank(),
#         panel.grid.minor = element_blank(),
#         panel.border = element_blank(),
#         panel.background = element_blank())
# #dev.off()
#
# # torsion velocity, two experiments together
# # pdf('perceptualErrorExp1&2.pdf')
# # ggplot(dataAll, aes(x=rotationSpeed, y=perceptualErrorMean, fill=exp)) +
# #   geom_boxplot(outlier.shape = NA, alpha = 0.7) +
# #   geom_point(aes(fill=exp), shape = 21, size = 2.5, position = position_jitterdodge()) +
# #   theme(axis.line = element_line(colour = "black"),
# #         panel.grid.major = element_blank(),
# #         panel.grid.minor = element_blank(),
# #         panel.border = element_blank(),
# #         panel.background = element_blank())
# # dev.off()

##############################################################################
# using trialData to plot!
trialData1Original <- read.csv("trialDataAllExp1.csv")
trialData2Original <- read.csv("trialDataAllExp2.csv")
# eye: 1 left eye, 2 right eye
# afterReversalD: -1 CCW, 1 CW, 0 merged as CW
# time window: -1 120ms after onset to flash onset; 0-flash onset to flash offset; 1 120ms after flash offset to end

# perceptual data
# Exp1
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == 1), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
torsionVelT <- trialData1["torsionVelT"] * trialData1["afterReversalD"]
dataExp1 <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionVelT)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)

dataAgg1 <- aggregate(. ~ rotationSpeed * sub, data = dataExp1, FUN = "mean")
dataAgg1$psd <- aggregate(perceptualError ~ rotationSpeed * sub, data = dataExp1, FUN = "sd")$perceptualError
dataAgg1$tsd <- aggregate(torsionVelT ~ rotationSpeed * sub, data = dataExp1, FUN = "sd")$torsionVelT

# # how well does the model fit for each factor
# p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = perceptualError, group = 1)) +
#   stat_summary(fun.data = mean_se,
#                geom = "errorbar", width=0.2) +
#   geom_line(stat = "summary", fun.y = "mean", size = 1) +
#   geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
# print(p)

## Exp2
trialData2 <- trialData2Original[which(trialData2Original$timeWindow == 1
& ((trialData2Original$eye == 1 & trialData2Original$targetSide == -1) | (trialData2Original$eye == 1 & trialData2Original$targetSide == -1))), ]
sub <- trialData2["sub"]
exp <- trialData2["exp"]
afterReversalD <- trialData2["afterReversalD"]
rotationSpeed <- trialData2["rotationSpeed"]
perceptualError <- trialData2["perceptualError"]
torsionVelT <- trialData2["torsionVelT"] * trialData2["afterReversalD"]
dataExp2 <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionVelT)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)
dataExp2$rotationSpeed <- as.factor(dataExp2$rotationSpeed)

dataAgg2 <- aggregate(. ~ rotationSpeed * sub, data = dataExp2, FUN = "mean")
dataAgg2$psd <- aggregate(perceptualError ~ rotationSpeed * sub, data = dataExp2, FUN = "sd")$perceptualError
dataAgg2$tsd <- aggregate(torsionVelT ~ rotationSpeed * sub, data = dataExp2, FUN = "sd")$torsionVelT

p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = torsionVelT)) +
    stat_summary(
        fun.data = mean_se,
        geom = "errorbar", width = 0.2
    ) +
    geom_line(stat = "summary", fun.y = "mean", size = 1)
print(p)
