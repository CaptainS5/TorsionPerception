library(psych)
library(car)
library(ggplot2)
library(ez)
library(ppcor)

## clear environment
rm(list=ls())

## load data
setwd("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/analysis")
baseTorsion1Original <- read.csv("conDataBaseAllExp1.csv")
baseTorsion2Original <- read.csv("trialDataBaseAllExp2.csv")
conData1Original <- read.csv('conDataAllExp1.csv')
trialData1Original <- read.csv("trialDataAllExp1.csv")
trialData2Original <- read.csv("trialDataAllExp2.csv")
trialDataBoth2Original <- read.csv("trialDataAllBothEyeExp2.csv")
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
dataExp1 <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualErrorMean)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)

perceptExp1Anova <- ezANOVA(dataExp1, dv = .(perceptualErrorMean), wid = .(sub),
                        within = .(rotationSpeed, afterReversalD),
                        type = 3)
print(perceptExp1Anova)

pdf('perceptErrorExp1_interaction.pdf')
p <- ggplot(dataExp1, aes(x = rotationSpeed, y = perceptualErrorMean, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean")
print(p)
dev.off()

# Exp2
trialData2 <- trialData2Original[which(trialData2Original$timeWindow==1), ]
sub <- trialData2["sub"]+20
exp <- trialData2["exp"]
afterReversalD <- trialData2["afterReversalD"]
rotationSpeed <- trialData2["rotationSpeed"]
perceptualError <- trialData2["perceptualError"]
dataTemp <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualError)
dataTemp$exp <- as.factor(dataTemp$exp)
dataTemp$sub <- as.factor(dataTemp$sub)
dataTemp$afterReversalD <- as.factor(dataTemp$afterReversalD)
dataTemp$rotationSpeed <- as.factor(dataTemp$rotationSpeed)
colnames(dataTemp)[5] <- "perceptualErrorMean"
# show(dataTemp)
dataExp2 <- aggregate(perceptualErrorMean ~ sub * rotationSpeed * exp * afterReversalD, data = dataTemp, FUN = "mean")
# dataExp2$psd <- aggregate(perceptualErrorMean ~ sub * rotationSpeed * exp * afterReversalD, data = dataTemp, FUN = "sd")$perceptualErrorMean
# show(dataExp2)

perceptExp2Anova <- ezANOVA(dataExp2, dv = .(perceptualErrorMean), wid = .(sub),
                            within = .(rotationSpeed, afterReversalD),
                            type = 3)
print(perceptExp2Anova)

pdf('perceptErrorExp2_interaction.pdf')
p <- ggplot(dataExp2, aes(x = rotationSpeed, y = perceptualErrorMean, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean")
print(p)
dev.off()

# two exps together--excluding 400 speed in Exp1
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

pdf('torsionVelTExp1_interaction3.pdf')
p <- ggplot(dataExp1, aes(x = rotationSpeed, y = torsionVelTMean, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()

# before reversal
# Partial correlation
conData1 <- conData1Original[which(conData1Original$afterReversalD==0 & conData1Original$timeWindow==-1), ]
sub <- conData1["sub"]
exp <- conData1["exp"]
rotationSpeed <- conData1["rotationSpeed"]
perceptualErrorMean <- conData1["perceptualErrorMean"]
torsionVelTMean <- conData1["torsionVelTMean"]
dataExp1 <- data.frame(sub, exp, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)

corExp1BR <- pcor.test(dataExp1$perceptualErrorMean, dataExp1$torsionVelTMean, dataExp1$rotationSpeed, method = c("pearson"))
print(corExp1BR)

# at reversal
conData1 <- conData1Original[which(conData1Original$afterReversalD==0 & conData1Original$timeWindow==0), ]
sub <- conData1["sub"]
exp <- conData1["exp"]
rotationSpeed <- conData1["rotationSpeed"]
perceptualErrorMean <- conData1["perceptualErrorMean"]
torsionVelTMean <- conData1["torsionVelTMean"]
dataExp1 <- data.frame(sub, exp, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)

corExp1R <- pcor.test(dataExp1$perceptualErrorMean, dataExp1$torsionVelTMean, dataExp1$rotationSpeed, method = c("pearson"))
print(corExp1R)

# after reversal
conData1 <- conData1Original[which(conData1Original$afterReversalD==0 & conData1Original$timeWindow==1), ]
sub <- conData1["sub"]
exp <- conData1["exp"]
rotationSpeed <- conData1["rotationSpeed"]
perceptualErrorMean <- conData1["perceptualErrorMean"]
torsionVelTMean <- conData1["torsionVelTMean"]
dataExp1 <- data.frame(sub, exp, rotationSpeed, perceptualErrorMean, torsionVelTMean)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)

corExp1AR <- pcor.test(dataExp1$perceptualErrorMean, dataExp1$torsionVelTMean, dataExp1$rotationSpeed, method = c("pearson"))
print(corExp1AR)

## Exp2
# baseline
# correlation between the two eyes
sub <- baseTorsion2Original["sub"]+20
rotationSpeed <- baseTorsion2Original["rotationSpeed"]
LtorsionVelT <- baseTorsion2Original["LtorsionVelT"]
RtorsionVelT <- baseTorsion2Original["RtorsionVelT"]
trialBase <- data.frame(sub, rotationSpeed, LtorsionVelT, RtorsionVelT)
trialBase$sub <- as.factor(trialBase$sub)
# trialBase$rotationSpeed <- as.factor(trialBase$rotationSpeed)

trialCor <- trialBase[complete.cases(trialBase), ]
corP <- matrix(0, 10, 1)
corR <- matrix(0, 10, 1)
for (subN in 21:30) {
    trialBaseS <- trialCor[which(trialCor$sub==subN), ]
# corB <- cor.test(trialBaseS$LtorsionVelT, trialBaseS$RtorsionVelT, use="complete.obs", method="pearson")
# corP[subN-20, 1] <- corB$estimate
# corR[subN-20, 1] <- corB$p.value
}
show(corP)
show(corR)

# pcorB <- pcor.test(trialCor$LtorsionVelT, trialCor$RtorsionVelT, trialCor$rotationSpeed, method = c("pearson"))
# print(pcorB)

pdf("correlationBaseTwoEyes.pdf")
p <- ggplot(trialCor, aes(x = LtorsionVelT, y = RtorsionVelT, color = rotationSpeed)) + geom_point()
print(p)
dev.off()

# histogram of velocity in each eye
pdf("baselineVelocityLeftEye.pdf")
p <- ggplot(trialCor, aes(LtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()

pdf("baselineVelocityRightEye.pdf")
p <- ggplot(trialCor, aes(RtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()

# # compare with zero?... not so good actually--maybe show more plots
# trialCor$LtorsionVelT <-
# conBase <- aggregate(. ~ rotationSpeed * sub, data = trialCor, FUN = "mean")
# tL <- t.test(conBase$LtorsionVelT, mu = 0)
# print(tL)
# tR <- t.test(conBase$RtorsionVelT, mu = 0)
# print(tR)
# tB <- t.test(conBase$LtorsionVelT, conBase$RtorsionVelT)
# print(tB)

# experiment trials, first do the same as baseline
# correlation... within subject
sub <- trialData2Original["sub"]+20
rotationSpeed <- trialData2Original["rotationSpeed"]
afterReversalD <- trialData2Original["afterReversalD"]
timeWindow <- trialData2Original["timeWindow"]
LtorsionVelT <- trialData2Original["LtorsionVelT"]
RtorsionVelT <- trialData2Original["RtorsionVelT"]
trialExpOriginal <- data.frame(sub, rotationSpeed, afterReversalD, timeWindow, LtorsionVelT, RtorsionVelT)

# before reversal
trialExp <- trialExpOriginal[which(trialExpOriginal$timeWindow==0), ]
trialExpCor <- trialExp[complete.cases(trialExp), ]
# corP <- matrix(0, 10, 1)
# corR <- matrix(0, 10, 1)
# for (subN in 21:30) {
#     trialExpS <- trialExpCor[which(trialExpCor$sub==subN), ]
# corE <- cor.test(trialExpS$LtorsionVelT, trialExpS$RtorsionVelT, use="complete.obs", method="pearson")
# corP[subN-20, 1] <- corE$estimate
# corR[subN-20, 1] <- corE$p.value
# }
# show(corP)
# show(corR)
#
# corEA <- cor.test(trialExpCor$LtorsionVelT, trialExpCor$RtorsionVelT, use="complete.obs", method="pearson")
# print(corEA)

pdf("correlationExpTwoEyes_afterReversal.pdf")
p <- ggplot(trialExpCor, aes(x = LtorsionVelT, y = RtorsionVelT, color = rotationSpeed)) + geom_point()
print(p)
dev.off()

# histogram of velocity in each eye
pdf("expVelocityLeftEye_afterReversal.pdf")
p <- ggplot(trialExpCor, aes(LtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()

pdf("expVelocityRightEye_afterReversal.pdf")
p <- ggplot(trialExpCor, aes(RtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()


pdf("correlationExpTwoEyes_atReversal.pdf")
p <- ggplot(trialExpCor, aes(x = LtorsionVelT, y = RtorsionVelT, color = rotationSpeed)) + geom_point()
print(p)
dev.off()

# histogram of velocity in each eye
pdf("expVelocityLeftEye_atReversal.pdf")
p <- ggplot(trialExpCor, aes(LtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()

pdf("expVelocityRightEye_atReversal.pdf")
p <- ggplot(trialExpCor, aes(RtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()


pdf("correlationExpTwoEyes_beforeReversal.pdf")
p <- ggplot(trialExpCor, aes(x = LtorsionVelT, y = RtorsionVelT, color = rotationSpeed)) + geom_point()
print(p)
dev.off()

# histogram of velocity in each eye
pdf("expVelocityLeftEye_beforeReversal.pdf")
p <- ggplot(trialExpCor, aes(LtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()

pdf("expVelocityRightEye_beforeReversal.pdf")
p <- ggplot(trialExpCor, aes(RtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
print(p)
dev.off()

## both-eyes
trialBoth2 <- trialDataBoth2Original
sub <- trialBoth2["sub"]+20
exp <- trialBoth2["exp"]
timeWindow <- trialBoth2["timeWindow"]
afterReversalD <- trialBoth2["afterReversalD"]
rotationSpeed <- trialBoth2["rotationSpeed"]
# perceptualError <- trialBoth2["perceptualError"]
torsionVelT <- trialBoth2["torsionVelT"]*trialBoth2["afterReversalD"]
dataBoth2 <- data.frame(sub, exp, timeWindow, afterReversalD, rotationSpeed, torsionVelT)
dataBoth2$exp <- as.factor(dataBoth2$exp)
dataBoth2$sub <- as.factor(dataBoth2$sub)
dataBoth2$timeWindow <- as.factor(dataBoth2$timeWindow)
dataBoth2$afterReversalD <- as.factor(dataBoth2$afterReversalD)
dataBoth2$rotationSpeed <- as.factor(dataBoth2$rotationSpeed)

conBoth2 <- aggregate(. ~ sub * exp * timeWindow * afterReversalD * rotationSpeed, data = dataBoth2, FUN = "mean")
colnames(conBoth2)[6] <- "torsionVelTMean"

torsionVBoth2Anova <- ezANOVA(conBoth2, dv = .(torsionVelTMean), wid = .(sub),
                            within = .(rotationSpeed, timeWindow, afterReversalD),
                            type = 3)
print(torsionVBoth2Anova)

pdf('torsionVelTBothExp2_interaction3.pdf')
p <- ggplot(conBoth2, aes(x = rotationSpeed, y = torsionVelTMean, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()

dataBoth2$torsionVelT <- abs(dataBoth2$torsionVelT)
conAbsBoth2 <- aggregate(. ~ sub * exp * timeWindow * afterReversalD * rotationSpeed, data = dataBoth2, FUN = "mean")
colnames(conAbsBoth2)[6] <- "torsionVelTMean"

torsionVAbsBoth2Anova <- ezANOVA(conAbsBoth2, dv = .(torsionVelTMean), wid = .(sub),
                            within = .(rotationSpeed, timeWindow, afterReversalD),
                            type = 3)
print(torsionVAbsBoth2Anova)

pdf('torsionVelTAbsExp2_interaction3.pdf')
p <- ggplot(conAbsBoth2, aes(x = rotationSpeed, y = torsionVelTMean, colour = afterReversalD, group = afterReversalD)) +
  stat_summary(fun.data = mean_se,
               geom = "errorbar", width=0.2) +
  geom_line(stat = "summary", fun.y = "mean") +
  # geom_line(aes(y = torsionVelTFit), stat = "summary", fun.y = "mean", colour = "black", size = 0.5) +
  facet_grid(~ timeWindow)
print(p)
dev.off()

# correlation between perception and torsion
