library(psych)
library(nlme)
library(car)
library(multcompView)
library(emmeans)
library(ggplot2)
library(rcompanion)
library(ez)

## clear environment
rm(list=ls())

## load data
setwd("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/analysis")
conData1Original <- read.csv('conDataAllExp1.csv')
conData2Original <- read.csv('conDataAllExp2BothEyes.csv')
# eye: 1 left eye, 2 right eye
# afterReversalD: -1 CCW, 1 CW, 0 merged as CW
# time window: -1 120ms after onset to flash onset; 0-flash onset to flash offset; 1 120ms after flash offset to end


## repeated measures ANOVA
# 2 way for perception--rotational speed x after-reversal direction
# perceptual illusion
# Exp1
conData1 <- conData1Original[which(conData1Original$timeWindow==1 & conData1Original$afterReversalD!=0), ]
sub <- conData1["sub"]
exp <- conData1["exp"]
afterReversalD <- conData1["afterReversalD"]
rotationSpeed <- conData1["rotationSpeed"]
perceptualErrorMean <- conData1["perceptualErrorMean"]
torsionVelTMean <- conData1["torsionVelTMean"]
dataExp1 <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)

perceptExp1Anova <- ezANOVA(dataExp1, dv = .(perceptualErrorMean), wid = .(sub), 
                        within = .(rotationSpeed, afterReversalD),
                        type = 3)
print(perceptExp1Anova)

# Exp2
conData2 <- conData2Original[which(conData2Original$timeWindow==1 & conData2Original$afterReversalD!=0), ]
sub <- conData2["sub"]+20
exp <- conData2["exp"]
afterReversalD <- conData2["afterReversalD"]
rotationSpeed <- conData2["rotationSpeed"]
perceptualErrorMean <- conData2["perceptualErrorMean"]
torsionVelTMean <- conData2["torsionVelTMean"]
dataExp2 <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)
dataExp2$rotationSpeed <- as.factor(dataExp2$rotationSpeed)

perceptExp2Anova <- ezANOVA(dataExp2, dv = .(perceptualErrorMean), wid = .(sub), 
                            within = .(rotationSpeed, afterReversalD),
                            type = 3)
print(perceptExp2Anova)

# two exps together--don't use ANOVA... use multilevel models!
dataAll <- rbind(dataExp1[which(dataExp1$rotationSpeed!=400), ], dataExp2, deparse.level = 1)

perceptAllAnova <- ezANOVA(dataAll, dv = .(perceptualErrorMean), wid = .(sub), 
                            within = .(rotationSpeed, afterReversalD), 
                           between = .(exp), type = 3)
print(perceptAllAnova)


# 3 way for torsion--time window x rotational speed x after-reversal direction
# Exp1
conData1 <- conData1Original[which(conData1Original$afterReversalD!=0), ]
sub <- conData1["sub"]
exp <- conData1["exp"]
timeWindow <- conData1["timeWindow"]
afterReversalD <- conData1["afterReversalD"]
rotationSpeed <- conData1["rotationSpeed"]
perceptualErrorMean <- conData1["perceptualErrorMean"]
torsionVelTMean <- conData1["torsionVelTMean"]*conData1["afterReversalD"]
dataExp1 <- data.frame(sub, exp, timeWindow, afterReversalD, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$timeWindow <- as.factor(dataExp1$timeWindow)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)

torsionVExp1Anova <- ezANOVA(dataExp1, dv = .(torsionVelTMean), wid = .(sub), 
                            within = .(rotationSpeed, timeWindow, afterReversalD),
                            type = 3)
print(torsionVExp1Anova)

# Exp2
conData2 <- conData2Original[which(conData2Original$afterReversalD!=0), ]
sub <- conData2["sub"]+20
exp <- conData2["exp"]
timeWindow <- conData2["timeWindow"]
afterReversalD <- conData2["afterReversalD"]
rotationSpeed <- conData2["rotationSpeed"]
perceptualErrorMean <- conData2["perceptualErrorMean"]
torsionVelTMean <- conData2["torsionVelTMean"]*conData2["afterReversalD"]
dataExp2 <- data.frame(sub, exp, timeWindow, afterReversalD, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$timeWindow <- as.factor(dataExp2$timeWindow)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)
dataExp2$rotationSpeed <- as.factor(dataExp2$rotationSpeed)

torsionVExp2Anova <- ezANOVA(dataExp2, dv = .(torsionVelTMean), wid = .(sub), 
                            within = .(rotationSpeed, timeWindow, afterReversalD),
                            type = 3)
print(torsionVExp2Anova)


torsionVExp2Anova <- ezANOVA(dataExp2, dv = .(torsionVelTMean), wid = .(sub), 
                             within = .(rotationSpeed, timeWindow, afterReversalD),
                             type = 3)
print(torsionVAbsExp2Anova)
