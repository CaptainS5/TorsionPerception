library(lme4)
library(lmerTest)
library(ggplot2)
library(car)
library(MASS)
library(multcomp)
library(lsm)

## clear environment
rm(list=ls())

## load data
setwd("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/analysis")
trialData1Original <- read.csv('trialDataAllExp1.csv')
trialData2Original <- read.csv('trialDataAllExp2.csv')
# eye: 1 left eye, 2 right eye
# afterReversalD: -1 CCW, 1 CW, 0 merged as CW
# time window: -1 120ms after onset to flash onset; 0-flash onset to flash offset; 1 120ms after flash offset to end


# perceptual illusion
# Exp1
trialData1 <- trialData1Original[which(trialData1Original$timeWindow==1 & trialData1Original$afterReversalD!=0), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
dataExp1 <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualError)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)

perceptExp1 <- lmer(perceptualError ~ afterReversalD + rotationSpeed + rotationSpeed*afterReversalD + (1|afterReversalD:sub) + (1|rotationSpeed:sub), 
      data = dataExp1, REML = FALSE)
summary(perceptExp1)
anova(perceptExp1, type = 3)
# post hoc comparisons
summary(glht(perceptExp1, linfct = mcp(afterReversalD = "Tukey")), test = adjusted("none"))
summary(glht(perceptExp1, linfct = mcp(rotationSpeed = "Tukey")), test = adjusted("bonferroni"))
# # post hoc for interaction
# dataItc <- dataExp1
# dataItc$speedDir <- interaction(dataItc$rotationSpeed, dataItc$afterReversalD)
# percept1PostHoc <- lmer(perceptualError ~ afterReversalD + rotationSpeed + speedDir + (1|sub),
#                         data = dataItc, REML = FALSE)
# summary(glht(percept1PostHoc, linfct = mcp(speedDir = "Tukey")), test = adjusted("none"))
# lsm.options(disable.pbkrtest=TRUE)
# lsmeans(perceptExp1, list(pairwise~rotationSpeed), adjust = "tukey")
lsmeans(perceptExp1, list(pairwise~afterReversalD), adjust = "none")
lsmeans(perceptExp1, list(pairwise~rotationSpeed:afterReversalD), adjust = "tukey")

dataExp1Fit <- dataExp1
dataExp1Fit$perceptualErrorFit <- predict(perceptExp1)

dataAgg1 <- aggregate(.~rotationSpeed*afterReversalD*sub, data = dataExp1Fit, FUN = "mean") 
dataAgg1$sd <- aggregate(perceptualError~rotationSpeed*afterReversalD*sub, data = dataExp1Fit, FUN = "sd")$perceptualError
dataAgg1$sdFit <- aggregate(perceptualErrorFit~rotationSpeed*afterReversalD*sub, data = dataExp1Fit, FUN = "sd")$perceptualErrorFit

# how well does the model fit for each factor
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = perceptualError, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
print(p)

p <- ggplot(dataAgg1, aes(x = afterReversalD, y = perceptualError, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
print(p)

# interaction of rotationSpeed and perceptualError
pdf('perceptErrorExp1_interaction.pdf')
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = perceptualError, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean")
print(p)
dev.off()

## Exp2
trialData2 <- trialData2Original[which(trialData2Original$timeWindow==1 & trialData2Original$afterReversalD!=0
                                       & ((trialData2Original$eye==1 & trialData2Original$targetSide==-1)|(trialData2Original$eye==2 & trialData2Original$targetSide==1))), ]
sub <- trialData2["sub"]
exp <- trialData2["exp"]
afterReversalD <- trialData2["afterReversalD"]
rotationSpeed <- trialData2["rotationSpeed"]
perceptualError <- trialData2["perceptualError"]
dataExp2 <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualError)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)
dataExp2$rotationSpeed <- as.factor(dataExp2$rotationSpeed)

perceptExp2 <- lmer(perceptualError ~ rotationSpeed + afterReversalD + rotationSpeed*afterReversalD + (1|sub) + (1|afterReversalD:sub) + (1|rotationSpeed:sub), 
                    data = dataExp2, REML = FALSE)
summary(perceptExp2)
anova(perceptExp2)
# post hoc comparisons
summary(glht(perceptExp2, linfct = mcp(rotationSpeed = "Tukey")), test = adjusted("bonferroni"))

dataExp2Fit <- dataExp2
dataExp2Fit$perceptualErrorFit <- predict(perceptExp2)

dataAgg2 <- aggregate(.~rotationSpeed*afterReversalD*sub, data = dataExp2Fit, FUN = "mean") 
dataAgg2$sd <- aggregate(perceptualError~rotationSpeed*afterReversalD*sub, data = dataExp2Fit, FUN = "sd")$perceptualError
dataAgg2$sdFit <- aggregate(perceptualErrorFit~rotationSpeed*afterReversalD*sub, data = dataExp2Fit, FUN = "sd")$perceptualErrorFit

# how well does the model fit for each factor
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = perceptualError, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
print(p)

p <- ggplot(dataAgg2, aes(x = afterReversalD, y = perceptualError, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
print(p)

# interaction of rotationSpeed and perceptualError
pdf('perceptErrorExp2_interaction.pdf')
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = perceptualError, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean")
print(p)
dev.off()

## both
dataAll <- rbind(dataExp1, dataExp2, deparse.level = 1)
perceptAll <- lmer(perceptualError ~ rotationSpeed + afterReversalD + exp 
                    + rotationSpeed*exp + afterReversalD*exp + rotationSpeed*afterReversalD 
                    + rotationSpeed*exp*afterReversalD + (1|sub), 
                    data = dataAll)
summary(perceptAll)
anova(perceptAll)
# post hoc comparisons
summary(glht(perceptAll, linfct = mcp(afterReversalD = "Tukey")), test = adjusted("none"))
summary(glht(perceptAll, linfct = mcp(rotationSpeed = "Tukey")), test = adjusted("bonferroni"))
# lsmeans(perceptAll, list(pairwise~rotationSpeed), adjust = "tukey")
# lsmeans(perceptAll, list(pairwise~afterReversalD), adjust = "tukey")
# lsmeans(perceptAll, list(pairwise~rotationSpeed:exp), adjust = "tukey")

dataAllFit <- dataAll
dataAllFit$perceptualErrorFit <- predict(perceptAll)

dataAggAll <- aggregate(.~rotationSpeed*afterReversalD*sub*exp, data = dataAllFit, FUN = "mean") 
dataAggAll$sd <- aggregate(perceptualError~rotationSpeed*afterReversalD*sub*exp, data = dataAllFit, FUN = "sd")$perceptualError
dataAggAll$sdFit <- aggregate(perceptualErrorFit~rotationSpeed*afterReversalD*sub*exp, data = dataAllFit, FUN = "sd")$perceptualErrorFit

# how well does the model fit for each factor
p <- ggplot(dataAggAll, aes(x = rotationSpeed, y = perceptualError, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
print(p)

p <- ggplot(dataAggAll, aes(x = afterReversalD, y = perceptualError, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
print(p)

p <- ggplot(dataAggAll, aes(x = exp, y = perceptualError, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = perceptualErrorFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5)
print(p)

# interaction of rotationSpeed and perceptualError
p <- ggplot(dataAggAll, aes(x = rotationSpeed, y = perceptualError, colour = exp, group = exp)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean")
print(p)


######## Torsion ########
# Exp1 
trialData1 <- trialData1Original[which(trialData1Original$afterReversalD!=0), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
afterReversalD <- trialData1["afterReversalD"]
timeWindow <- trialData1["timeWindow"]
rotationSpeed <- trialData1["rotationSpeed"]
torsionVelT <- trialData1["torsionVelT"]*trialData1["afterReversalD"]
dataExp1 <- data.frame(sub, exp, afterReversalD, timeWindow, rotationSpeed, torsionVelT)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$timeWindow <- as.factor(dataExp1$timeWindow)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)

torsionVExp1 <- lmer(torsionVelT ~ timeWindow + afterReversalD + rotationSpeed 
                     + rotationSpeed*afterReversalD + timeWindow*rotationSpeed + timeWindow*afterReversalD
                     + rotationSpeed*afterReversalD*timeWindow 
                     + (1|sub) + (1|afterReversalD:sub) + (1|rotationSpeed:sub) + (1|timeWindow:sub), 
                    data = dataExp1, REML = FALSE)
summary(torsionVExp1)
anova(torsionVExp1)


dataExp1Fit <- dataExp1
dataExp1Fit$torsionVelTFit <- predict(torsionVExp1)

dataAgg1 <- aggregate(.~rotationSpeed*afterReversalD*sub*timeWindow, data = dataExp1Fit, FUN = "mean") 
dataAgg1$sd <- aggregate(torsionVelT~rotationSpeed*afterReversalD*sub*timeWindow, data = dataExp1Fit, FUN = "sd")$torsionVelT
dataAgg1$sdFit <- aggregate(torsionVelTFit~rotationSpeed*afterReversalD*sub*timeWindow, data = dataExp1Fit, FUN = "sd")$torsionVelTFit

# how well does the model fit for each factor
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionVelT, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5) +
  facet_grid(afterReversalD ~ timeWindow)
print(p)

p <- ggplot(dataAgg1, aes(x = afterReversalD, y = torsionVelT, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)

# interactions
pdf('torsionVelTmergedExp1_interaction2_speedTime.pdf')
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionVelT)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()

pdf('torsionVelTmergedExp1_interaction2_dirTime.pdf')
p <- ggplot(dataAgg1, aes(x = afterReversalD, y = torsionVelT)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()

pdf('torsionVelTmergedExp1_interaction3.pdf')
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()

# Exp2 
trialData2 <- trialData2Original[which(trialData2Original$afterReversalD!=0 & trialData2Original$timeWindow!=0
                                       & ((trialData2Original$eye==1 & trialData2Original$targetSide==-1)|(trialData2Original$eye==2 & trialData2Original$targetSide==1))), ]
sub <- trialData2["sub"]
exp <- trialData2["exp"]
afterReversalD <- trialData2["afterReversalD"]
timeWindow <- trialData2["timeWindow"]
rotationSpeed <- trialData2["rotationSpeed"]
torsionVelT <- trialData2["torsionVelT"]*trialData2["afterReversalD"]
dataExp2 <- data.frame(sub, exp, afterReversalD, timeWindow, rotationSpeed, torsionVelT)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$timeWindow <- as.factor(dataExp2$timeWindow)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)
dataExp2$rotationSpeed <- as.factor(dataExp2$rotationSpeed)

torsionVExp2 <- lmer(torsionVelT ~ timeWindow + afterReversalD + rotationSpeed 
                     + rotationSpeed*afterReversalD + timeWindow*rotationSpeed + timeWindow*afterReversalD
                     + rotationSpeed*afterReversalD*timeWindow 
                     + (1|sub),#(1|afterReversalD:sub) + (1|rotationSpeed:sub) + (1|timeWindow:sub),  
                     data = dataExp2, REML = FALSE)
summary(torsionVExp2)
anova(torsionVExp2)


dataExp2Fit <- dataExp2
dataExp2Fit$torsionVelTFit <- predict(torsionVExp2)

dataAgg2 <- aggregate(.~rotationSpeed*afterReversalD*sub*timeWindow, data = dataExp2Fit, FUN = "mean") 
dataAgg2$sd <- aggregate(torsionVelT~rotationSpeed*afterReversalD*sub*timeWindow, data = dataExp2Fit, FUN = "sd")$torsionVelT
dataAgg2$sdFit <- aggregate(torsionVelTFit~rotationSpeed*afterReversalD*sub*timeWindow, data = dataExp2Fit, FUN = "sd")$torsionVelTFit

# how well does the model fit for each factor
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = torsionVelT, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5) +
  facet_grid(afterReversalD ~ timeWindow)
print(p)

p <- ggplot(dataAgg2, aes(x = afterReversalD, y = torsionVelT, group = 1)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean", size = 1) +
  geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "red", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)

# interactions
pdf('torsionVelTmergedExp2_interaction2_speedTime.pdf')
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = torsionVelT)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()

pdf('torsionVelTAbsExp2_interaction3.pdf')
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = abs(torsionVelT), colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()
