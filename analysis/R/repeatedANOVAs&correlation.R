library(ggplot2)
library(ez)
library(lme4)
library(nlme)
library(ppcor)
library(multcomp)

#### clear environment
rm(list = ls())

#### load data
# on ASUS
setwd("E:/XiuyunWu/Torsion-FDE/analysis/R")
# # on XPS13
# setwd("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1stYear/TorsionPerception/analysis")
source("pairwise.t.test.with.t.and.df.R")
baseTorsion1Original <- read.csv("trialDataBaseAllExp1.csv")
baseTorsion2Original <- read.csv("trialDataBaseAllExp2.csv")
trialData1Original <- read.csv("trialDataAllExp1.csv")
trialData2Original <- read.csv("trialDataAllExp2.csv")
trialDataBoth2Original <- read.csv("trialDataAllBothEyeExp2.csv")
# eye: 1 left eye, 2 right eye afterReversalD: -1 CCW, 1 CW, 0 merged as CW time
# window: -1 120ms after onset to flash onset; 0-flash onset to flash offset; 1
# 120ms after flash offset to end
tw <- c(-1, 1)
endName <- c("beforeReversal", "afterReversal")

#### perceptual illusion repeated measures ANOVA
### 2 way for perception--rotational speed x after-reversal direction
## Exp1
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == 1), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
# afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
dataTemp <- data.frame(sub, exp, rotationSpeed, perceptualError)
dataTemp$exp <- as.factor(dataTemp$exp)
dataTemp$sub <- as.factor(dataTemp$sub)
# dataTemp$afterReversalD <- as.factor(dataTemp$afterReversalD)
dataTemp$rotationSpeed <- as.factor(dataTemp$rotationSpeed)
colnames(dataTemp)[4] <- "perceptualErrorMean"
dataExp1 <- aggregate(perceptualErrorMean ~ sub * rotationSpeed * exp,
    data = dataTemp, FUN = "mean")

perceptExp1Anova <- ezANOVA(dataExp1, dv = .(perceptualErrorMean), wid = .(sub),
    within = .(rotationSpeed), type = 3)
print(perceptExp1Anova)
# pdf("perceptErrorExp1_interaction.pdf")
p <- ggplot(dataExp1, aes(x = rotationSpeed, y = perceptualErrorMean,)) + stat_summary(fun.data = mean_se, geom = "errorbar",
    width = 0.2) + geom_line(stat = "summary", fun.y = "mean")
print(p)
# dev.off()

## Exp2
trialData2 <- trialData2Original[which(trialData2Original$timeWindow == 1), ]
sub <- trialData2["sub"] + 20
exp <- trialData2["exp"]
# afterReversalD <- trialData2["afterReversalD"]
rotationSpeed <- trialData2["rotationSpeed"]
perceptualError <- trialData2["perceptualError"]
dataTemp <- data.frame(sub, exp, rotationSpeed, perceptualError)
dataTemp$exp <- as.factor(dataTemp$exp)
dataTemp$sub <- as.factor(dataTemp$sub)
# dataTemp$afterReversalD <- as.factor(dataTemp$afterReversalD)
dataTemp$rotationSpeed <- as.factor(dataTemp$rotationSpeed)
colnames(dataTemp)[4] <- "perceptualErrorMean"
dataExp2 <- aggregate(perceptualErrorMean ~ sub * rotationSpeed * exp,
    data = dataTemp, FUN = "mean")

perceptExp2Anova <- ezANOVA(dataExp2, dv = .(perceptualErrorMean), wid = .(sub),
    within = .(rotationSpeed), type = 3)
print(perceptExp2Anova)

pdf("perceptErrorExp2_interaction.pdf")
p <- ggplot(dataExp2, aes(x = rotationSpeed, y = perceptualErrorMean)) + stat_summary(fun.data = mean_se, geom = "errorbar",
    width = 0.2) + geom_line(stat = "summary", fun.y = "mean")
print(p)
dev.off()

## two exps together--excluding 400 speed in Exp1
dataAll <- rbind(dataExp1[which(dataExp1$rotationSpeed != 400), ], dataExp2, deparse.level = 1)

perceptAllAnova <- ezANOVA(dataAll, dv = .(perceptualErrorMean), wid = .(sub), within = .(rotationSpeed,
    afterReversalD), between = .(exp), type = 3)
print(perceptAllAnova)


#### Torsion and perception data
### Exp1
## 2 way for torsional velocity--rotational speed x after-reversal direction, in each time window
# before reversal
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == -1), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
# afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
torsionVelT <- trialData1["torsionVelT"] * trialData1["afterReversalD"]
dataExp1b <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionVelT)
dataExp1b$exp <- as.factor(dataExp1b$exp)
dataExp1b$sub <- as.factor(dataExp1b$sub)
# dataExp1b$afterReversalD <- as.factor(dataExp1b$afterReversalD)
dataExp1b$rotationSpeed <- as.factor(dataExp1b$rotationSpeed)

dataAgg1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1b, FUN = "mean")
# show(dataExp1b)
# dataAgg1$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1b, FUN = "sd")$perceptualError
# dataAgg1$tsd <- aggregate(torsionVelT ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1b, FUN = "sd")$torsionVelT
# dataAgg1$torsionVelT <- abs(dataAgg1$torsionVelT)

torsionVExp1Anova <- ezANOVA(dataAgg1, dv = .(torsionVelT), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionVExp1Anova)

# after reversal
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == 1), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
# afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
torsionVelT <- trialData1["torsionVelT"] * trialData1["afterReversalD"]
dataExp1a <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionVelT)
dataExp1a$exp <- as.factor(dataExp1a$exp)
dataExp1a$sub <- as.factor(dataExp1a$sub)
# dataExp1a$afterReversalD <- as.factor(dataExp1a$afterReversalD)
dataExp1a$rotationSpeed <- as.factor(dataExp1a$rotationSpeed)

dataAgg1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1a, FUN = "mean")
# show(dataExp1a)
# dataAgg1$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1a, FUN = "sd")$perceptualError
# dataAgg1$tsd <- aggregate(torsionVelT ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1a, FUN = "sd")$torsionVelT
# dataAgg1$torsionVelT <- abs(dataAgg1$torsionVelT)

torsionVExp1Anova <- ezANOVA(dataAgg1, dv = .(torsionVelT), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionVExp1Anova)

# # post hoc for time window & afterReversalD interaction
# postHocs <- ezStats(dataAgg1, dv = .(torsionVelT), wid = .(sub), within = .(timeWindow, afterReversalD))
# print(postHocs) # means
#
# dataPH <- aggregate(. ~ afterReversalD * exp * sub * timeWindow, data = dataExp1, FUN = "mean")
# # show(dataPH[which(dataPH$timeWindow==-1), ])
# res <- pairwise.t.test.with.t.and.df(x = dataPH[which(dataPH$timeWindow==-1), ]$torsionVelT, g = dataPH[which(dataPH$timeWindow==-1), ]$afterReversalD, p.adj="none")
# show(res) # [[3]] = p value table, un adjusted
# res[[5]] # t-value
# res[[6]] # dfs
# res[[3]]
# p.adjust(res[[3]], method = "bonferroni", n = 15) # interaction between timeWindow & afterReversalD
#
#
# pdf("torsionVelTExp1_interaction3.pdf")
# p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD,
#     group = afterReversalD)) + stat_summary(fun.data = mean_se, geom = "errorbar",
#     width = 0.2) + geom_line(stat = "summary", fun.y = "mean") + facet_grid(~timeWindow)
# print(p)
# dev.off()

## Partial correlation across participants before reversal
# dataT <- dataExp1[which(dataExp1$timeWindow==-1),]
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == -1), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
# afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
torsionVelT <- trialData1["torsionVelT"] * trialData1["afterReversalD"]
dataExp1b <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionVelT)
dataExp1b$exp <- as.factor(dataExp1b$exp)
dataExp1b$sub <- as.factor(dataExp1b$sub)
# dataAggCor1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1b, FUN = "median")
# dataAggCor1 <- aggregate(. ~ exp * sub, data = dataAggCor1, FUN = "mean")
dataExp1b$rotationSpeed <- as.numeric(dataExp1b$rotationSpeed)
dataAggCor1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1b, FUN = "mean")
# str(dataAggCor1)
show(dataAggCor1)

# corExp1BR <- cor.test(dataAggCor1$perceptualError, dataAggCor1$torsionVelT, method = c("pearson"))
corExp1BR <- pcor.test(dataAggCor1$perceptualError, dataAggCor1$torsionVelT, dataAggCor1$rotationSpeed,
    method = c("pearson"))
print(corExp1BR)

# # at reversal
# dataT <- dataExp1[which(dataExp1$timeWindow==0),]
# dataAggCor1 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub, data = dataT, FUN = "mean")
#
# corExp1BR <- pcor.test(dataAggCor1$perceptualError, dataAggCor1$torsionVelT, dataAggCor1$rotationSpeed,
#     method = c("pearson"))
# print(corExp1BR)

# after reversal
# dataT <- dataExp1[which(dataExp1$timeWindow==1),]
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == 1), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
# afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
torsionVelT <- trialData1["torsionVelT"] * trialData1["afterReversalD"]
dataExp1a <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionVelT)
dataExp1a$exp <- as.factor(dataExp1a$exp)
dataExp1a$sub <- as.factor(dataExp1a$sub)
# dataAggCor1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1a, FUN = "median")
# dataAggCor1 <- aggregate(. ~ exp * sub, data = dataAggCor1, FUN = "mean")
dataExp1a$rotationSpeed <- as.numeric(dataExp1a$rotationSpeed)
dataAggCor1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1a, FUN = "mean")

# corExp1BR <- cor.test(dataAggCor1$perceptualError, dataAggCor1$torsionVelT, method = c("pearson"))
corExp1BR <- pcor.test(dataAggCor1$perceptualError, dataAggCor1$torsionVelT, dataAggCor1$rotationSpeed,
    method = c("pearson"))
print(corExp1BR)

## 2 way for torsional angle--time window x rotational speed x after-reversal direction
# before reversal
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == -1), ]
trialData1["torsionAngleCCW"] <- -trialData1["torsionAngleCCW"]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
# afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
torsionAngle <- trialData1["torsionAngle"] * trialData1["afterReversalD"]
# torsionAngleSame <- trialData1["torsionAngleCW"] * trialData1["afterReversalD"]
# idx <- trialData1$afterReversalD * trialData1$timeWindow==-1
# torsionAngleSame[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
# idx <- which(trialData1$timeWindow==0 & trialData1$afterReversalD==1)
# torsionAngleSame[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
# torsionAngleDiff <- trialData1["torsionAngleCW"] * trialData1["afterReversalD"]
# idx <- trialData1$afterReversalD * trialData1$timeWindow==1
# torsionAngleDiff[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
# idx <- which(trialData1$timeWindow==0 & trialData1$afterReversalD==-1)
# torsionAngleDiff[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]

dataExp1b <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionAngle)
dataExp1b$exp <- as.factor(dataExp1b$exp)
dataExp1b$sub <- as.factor(dataExp1b$sub)
# dataExp1b$afterReversalD <- as.factor(dataExp1b$afterReversalD)
dataExp1b$rotationSpeed <- as.factor(dataExp1b$rotationSpeed)
show(dataExp1b)
# colnames(dataExp1b)[5] <- "torsionAngleSame"
# colnames(dataExp1b)[6] <- "torsionAngleDiff"

dataAgg1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1b, FUN = "mean")
# dataAgg1$torsionAngleSame <- abs(dataAgg1$torsionAngleSame)
# use absolute values
torsionAExp1Anova <- ezANOVA(dataAgg1, dv = .(torsionAngle), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionAExp1Anova)

# after reversal
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == 1), ]
trialData1["torsionAngleCCW"] <- -trialData1["torsionAngleCCW"]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
# afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
torsionAngle <- trialData1["torsionAngle"] * trialData1["afterReversalD"]
# torsionAngleSame <- trialData1["torsionAngleCW"] * trialData1["afterReversalD"]
# idx <- trialData1$afterReversalD * trialData1$timeWindow==-1
# torsionAngleSame[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
# idx <- which(trialData1$timeWindow==0 & trialData1$afterReversalD==1)
# torsionAngleSame[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
# torsionAngleDiff <- trialData1["torsionAngleCW"] * trialData1["afterReversalD"]
# idx <- trialData1$afterReversalD * trialData1$timeWindow==1
# torsionAngleDiff[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
# idx <- which(trialData1$timeWindow==0 & trialData1$afterReversalD==-1)
# torsionAngleDiff[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]

dataExp1a <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionAngle)
dataExp1a$exp <- as.factor(dataExp1a$exp)
dataExp1a$sub <- as.factor(dataExp1a$sub)
# dataExp1a$afterReversalD <- as.factor(dataExp1a$afterReversalD)
dataExp1a$rotationSpeed <- as.factor(dataExp1a$rotationSpeed)
# show(dataExp1a)
# colnames(dataExp1a)[5] <- "torsionAngleSame"
# colnames(dataExp1a)[6] <- "torsionAngleDiff"

dataAgg1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1a, FUN = "mean")
# dataAgg1$torsionAngleSame <- abs(dataAgg1$torsionAngleSame)
# use absolute values
torsionAExp1Anova <- ezANOVA(dataAgg1, dv = .(torsionAngle), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionAExp1Anova)

# # pdf("torsionAngleExp1_interaction3.pdf")
# p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD,
#     group = afterReversalD)) + stat_summary(fun.data = mean_se, geom = "errorbar",
#     width = 0.2) + geom_line(stat = "summary", fun.y = "mean") + facet_grid(~timeWindow)
# print(p)
# # dev.off()

## Partial correlation across participants before reversal
# dataT <- dataExp1[which(dataExp1$timeWindow==-1),]
dataAggCor1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1b, FUN = "median")
dataAggCor1 <- aggregate(. ~ exp * sub, data = dataAggCor1, FUN = "mean")
# show(dataAggCor1)

corExp1BR <- cor.test(dataAggCor1$perceptualError, dataAggCor1$torsionAngle, method = c("pearson"))
print(corExp1BR)

# # at reversal
# dataT <- dataExp1[which(dataExp1$timeWindow==0),]
# dataAggCor1 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub, data = dataT, FUN = "mean")
#
# corExp1BR <- pcor.test(dataAggCor1$perceptualError, dataAggCor1$torsionAngleSame, dataAggCor1$rotationSpeed,
#     method = c("pearson"))
# print(corExp1BR)

# after reversal
# dataT <- dataExp1[which(dataExp1$timeWindow==1),]
dataAggCor1 <- aggregate(. ~ rotationSpeed * exp * sub, data = dataExp1a, FUN = "median")
dataAggCor1 <- aggregate(. ~ exp * sub, data = dataAggCor1, FUN = "mean")

corExp1BR <- cor.test(dataAggCor1$perceptualError, dataAggCor1$torsionAngle, method = c("pearson"))
print(corExp1BR)

### Exp2 baseline correlation between the two eyes
sub <- baseTorsion2Original["sub"] + 20
rotationSpeed <- baseTorsion2Original["rotationSpeed"]
LtorsionVelT <- baseTorsion2Original["LtorsionVelT"]
RtorsionVelT <- baseTorsion2Original["RtorsionVelT"]
trialBase <- data.frame(sub, rotationSpeed, LtorsionVelT, RtorsionVelT)
trialBase$sub <- as.factor(trialBase$sub)
# trialBase$rotationSpeed <- as.factor(trialBase$rotationSpeed)

## correlation within participant
trialCor <- trialBase[complete.cases(trialBase), ]
corP <- matrix(0, 10, 1)
corR <- matrix(0, 10, 1)
for (subN in 21:30) {
    trialBaseS <- trialCor[which(trialCor$sub == subN), ]
    corB <- cor.test(trialBaseS$LtorsionVelT, trialBaseS$RtorsionVelT, use = "complete.obs",
        method = "pearson")
    corR[subN - 20, 1] <- corB$estimate
    corP[subN - 20, 1] <- corB$p.value
}
show(corR)
show(corP)
corS <- corR[corP<0.05, 1]
print(length(corS))
print(mean(corS))
print(sd(corS))

# partial correlation across participants
pcorB <- pcor.test(trialCor$LtorsionVelT, trialCor$RtorsionVelT, trialCor$rotationSpeed,
    method = c("pearson"))
print(pcorB)

### experiment trials, first do the same as baseline correlation between the two eyes within subject
sub <- trialData2Original["sub"] + 20
rotationSpeed <- trialData2Original["rotationSpeed"]
afterReversalD <- trialData2Original["afterReversalD"]
timeWindow <- trialData2Original["timeWindow"]
LtorsionVelT <- trialData2Original["LtorsionVelT"]
RtorsionVelT <- trialData2Original["RtorsionVelT"]
trialExpOriginal <- data.frame(sub, rotationSpeed, afterReversalD, timeWindow, LtorsionVelT,
    RtorsionVelT)

# loop through time windows
for (endN in 3:3) {
    trialExp <- trialExpOriginal[which(trialExpOriginal$timeWindow == tw[endN] &
        abs(trialExpOriginal$LtorsionVelT) < 6), ]
    trialExpCor <- trialExp[complete.cases(trialExp), ]
    corP <- matrix(0, 10, 1)
    corR <- matrix(0, 10, 1)
    for (subN in 21:30) {
        trialExpS <- trialExpCor[which(trialExpCor$sub == subN), ]
        corE <- cor.test(trialExpS$LtorsionVelT, trialExpS$RtorsionVelT, use = "complete.obs",
            method = "pearson")
        corR[subN - 20, 1] <- corE$estimate
        corP[subN - 20, 1] <- corE$p.value
    }
    # show(corR)
    # show(corP)
    corS <- corR[corP<0.05, 1]
    print(length(corS))
    print(mean(corS))
    print(sd(corS))

    # across sub trial correlation...
    # corEA <- cor.test(trialExpCor$LtorsionVelT, trialExpCor$RtorsionVelT, use = "complete.obs",
    #     method = "pearson")
    # print(corEA)
    # partial correlation
    pcorEA <- pcor.test(trialExpCor$LtorsionVelT, trialExpCor$RtorsionVelT, trialExpCor$rotationSpeed,
        method = c("pearson"))
    print(pcorEA)

    # pdf(paste("correlationExpTwoEyes_", endName[endN], ".pdf"))
    # p <- ggplot(trialExpCor, aes(x = LtorsionVelT, y = RtorsionVelT, color = rotationSpeed)) +
    #     geom_point()
    # print(p)
    # dev.off()
    #
    # # histogram of velocity in each eye
    # pdf(paste("expVelocityLeftEye_", endName[endN], ".pdf"))
    # p <- ggplot(trialExpCor, aes(LtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
    # print(p)
    # dev.off()
    #
    # pdf(paste("expVelocityRightEye_", endName[endN], ".pdf"))
    # p <- ggplot(trialExpCor, aes(RtorsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
    # print(p)
    # dev.off()
}


## both-eyes
# torsional velocity
# before reversal
trialBoth2 <- trialDataBoth2Original[which(trialDataBoth2Original$timeWindow == 1), ]#[which(abs(trialDataBoth2Original$torsionVelT) <
    # 6), ]
sub <- trialBoth2["sub"] + 20
exp <- trialBoth2["exp"]
# afterReversalD <- trialBoth2["afterReversalD"]
rotationSpeed <- trialBoth2["rotationSpeed"]
perceptualError <- trialBoth2["perceptualError"]
torsionVelT <- trialBoth2["torsionVelT"] * trialBoth2["afterReversalD"]
dataBoth2b <- data.frame(sub, exp, rotationSpeed, torsionVelT,
    perceptualError)
dataBoth2b$exp <- as.factor(dataBoth2b$exp)
dataBoth2b$sub <- as.factor(dataBoth2b$sub)
# dataBoth2b$afterReversalD <- as.factor(dataBoth2b$afterReversalD)
# dataBoth2b$rotationSpeed <- as.factor(dataBoth2b$rotationSpeed)

conBoth2 <- aggregate(torsionVelT ~ sub * exp * rotationSpeed,
    data = dataBoth2b, FUN = "mean")
    # show(conBoth2)
colnames(conBoth2)[4] <- "torsionVelTMean"
# conBoth2$torsionVelTMean <- abs(conBoth2$torsionVelTMean)

torsionVBoth2Anova <- ezANOVA(conBoth2, dv = .(torsionVelTMean), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionVBoth2Anova)
# postTime <- ezStats(conBoth2, dv = .(torsionVelTMean), wid = .(sub), within = .(timeWindow))
# print(postTime)
# postD <- ezStats(conBoth2, dv = .(torsionVelTMean), wid = .(sub), within = .(afterReversalD))
# print(postD)

# conBoth2 <- aggregate(torsionVelT ~ sub * afterReversalD,
#     data = dataBoth2, FUN = "mean")
# colnames(conBoth2)[3] <- "torsionVelTMean"
# conBoth2$torsionVelTMean <- abs(conBoth2$torsionVelTMean)

# pdf("torsionVelTBothExp2_interaction3.pdf")
p <- ggplot(conBoth2, aes(x = rotationSpeed, y = torsionVelTMean, colour = afterReversalD,
    group = afterReversalD)) + stat_summary(fun.data = mean_se, geom = "errorbar",
    width = 0.2) + geom_line(stat = "summary", fun.y = "mean")
print(p)
# dev.off()

# correlation
conCorBoth2 <- aggregate(cbind(torsionVelT, perceptualError) ~ sub * exp *
    rotationSpeed, data = dataBoth2b, FUN = "mean")
colnames(conCorBoth2)[4] <- "torsionVelTMean"
colnames(conCorBoth2)[5] <- "perceptualErrorMean"
# conCorBoth2$rotationSpeed <- as.numeric(conCorBoth2$rotationSpeed)
# conCorBoth2 <- aggregate(. ~ sub * exp, data = conCorBoth2, FUN = "mean")
# show(conCorBoth2)

corExp2 <- pcor.test(conCorBoth2$perceptualErrorMean, conCorBoth2$torsionVelTMean, conCorBoth2$rotationSpeed, method = c("pearson"))
print(corExp2)

# after reversal
trialBoth2 <- trialDataBoth2Original[which(trialData1Original$timeWindow == 1), ]#[which(abs(trialDataBoth2Original$torsionVelT) <
    # 6), ]
sub <- trialBoth2["sub"] + 20
exp <- trialBoth2["exp"]
# afterReversalD <- trialBoth2["afterReversalD"]
rotationSpeed <- trialBoth2["rotationSpeed"]
perceptualError <- trialBoth2["perceptualError"]
torsionVelT <- trialBoth2["torsionVelT"] * trialBoth2["afterReversalD"]
dataBoth2a <- data.frame(sub, exp, rotationSpeed, torsionVelT,
    perceptualError)
dataBoth2a$exp <- as.factor(dataBoth2a$exp)
dataBoth2a$sub <- as.factor(dataBoth2a$sub)
# dataBoth2a$afterReversalD <- as.factor(dataBoth2a$afterReversalD)
dataBoth2a$rotationSpeed <- as.factor(dataBoth2a$rotationSpeed)

conBoth2 <- aggregate(torsionVelT ~ sub * exp * rotationSpeed,
    data = dataBoth2a, FUN = "mean")
    # show(conBoth2)
colnames(conBoth2)[4] <- "torsionVelTMean"
# conBoth2$torsionVelTMean <- abs(conBoth2$torsionVelTMean)

torsionVBoth2Anova <- ezANOVA(conBoth2, dv = .(torsionVelTMean), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionVBoth2Anova)

## correlation between perception and torsion
conCorBoth2 <- aggregate(cbind(torsionVelT, perceptualError) ~ sub * exp *
    rotationSpeed, data = dataBoth2a, FUN = "median")
colnames(conCorBoth2)[4] <- "torsionVelTMean"
colnames(conCorBoth2)[5] <- "perceptualErrorMean"
conCorBoth2 <- aggregate(. ~ sub * exp, data = conCorBoth2, FUN = "mean")

corExp2 <- cor.test(conCorBoth2$perceptualErrorMean, conCorBoth2$torsionVelTMean, method = c("pearson"))
print(corExp2)

# # uncomment if want to see both-eye absolute values--not so meaningful either...
# dataBoth2$torsionVelT <- abs(dataBoth2$torsionVelT)
# conBoth2 <- aggregate(torsionVelT ~ sub * exp * timeWindow * afterReversalD * rotationSpeed,
#     data = dataBoth2, FUN = "mean")
# colnames(conBoth2)[6] <- "torsionVelTMean"
# torsionVAbsBoth2Anova <- ezANOVA(conBoth2, dv = .(torsionVelTMean), wid = .(sub),
#     within = .(rotationSpeed, timeWindow, afterReversalD), type = 3)
# print(torsionVAbsBoth2Anova)
#
# pdf("torsionVelTAbsBothExp2_interaction3.pdf")
# p <- ggplot(conBoth2, aes(x = rotationSpeed, y = torsionVelTMean, colour = afterReversalD,
#     group = afterReversalD)) + stat_summary(fun.data = mean_se, geom = "errorbar",
#     width = 0.2) + geom_line(stat = "summary", fun.y = "mean") + facet_grid(~timeWindow)
# print(p)
# dev.off()

# loop through time windows
# for (endN in 1:2) {
    ## histogram of velocity
    # histData2 <- dataBoth2[which(dataBoth2$timeWindow == tw[endN]), ]
    # pdf(paste("exp2Velocity_", endName[endN], ".pdf"))
    # p <- ggplot(histData2, aes(torsionVelT)) + geom_histogram() + facet_wrap(~rotationSpeed)
    # print(p)
    # dev.off()

    # # uncomment if want to see both-eye absolute values--not so meaningful either...
    # dataBoth2$torsionVelT <- abs(dataBoth2$torsionVelT)

    # ## correlation between perception and torsion
    # conCorBoth2 <- aggregate(cbind(torsionVelT, perceptualError) ~ sub * exp *
    #     rotationSpeed, data = dataBoth2b, FUN = "mean")
    # colnames(conCorBoth2)[4] <- "torsionVelTMean"
    # colnames(conCorBoth2)[5] <- "perceptualErrorMean"
    # conCorBoth2$rotationSpeed <- as.numeric(conCorBoth2$rotationSpeed)
    #
    # corExp2 <- pcor.test(conCorBoth2$perceptualErrorMean, conCorBoth2$torsionVelTMean,
    #     conCorBoth2$rotationSpeed, method = c("pearson"))
    # print(corExp2)

    # dataBoth2$rotationSpeed <- as.numeric(dataBoth2$rotationSpeed)
    # trialExpCor <- dataBoth2[which(dataBoth2$timeWindow == tw[endN]), ]
    # corP <- matrix(0, 10, 1)
    # corR <- matrix(0, 10, 1)
    # for (subN in 21:30) {
    #     trialExpS <- trialExpCor[which(trialExpCor$sub == subN), ]
    #     corE <- cor.test(trialExpS$torsionVelT, trialExpS$perceptualError, use = "complete.obs",
    #         method = "pearson")
    #     corP[subN - 20, 1] <- corE$estimate
    #     corR[subN - 20, 1] <- corE$p.value
    # }
    # show(corP)
    # show(corR)

    # pdf(paste("correlationExp2_", endName[endN], ".pdf"))
    # p <- ggplot(conCorBothT, aes(x = perceptualErrorMean, y = torsionVelTMean, colour = rotationSpeed)) +
    #     geom_point()
    # print(p)
    # dev.off()
    #
    # pdf(paste("correlationPerSpeedExp2_", endName[endN], ".pdf"))
    # p <- ggplot(conCorBothT, aes(x = perceptualErrorMean, y = torsionVelTMean)) +
    #     geom_point() + facet_wrap(~rotationSpeed)
    # print(p)
    # dev.off()
}

# torsional angle
# trialBoth2 <- trialDataBoth2Original[which(abs(trialDataBoth2Original$torsionVelT) <
#     6), ]
# before reversal
trialBoth2 <- trialDataBoth2Original[which(trialDataBoth2Original$timeWindow == -1), ]
sub <- trialBoth2["sub"] + 20
exp <- trialBoth2["exp"]
# afterReversalD <- trialBoth2["afterReversalD"]
rotationSpeed <- trialBoth2["rotationSpeed"]
perceptualError <- trialBoth2["perceptualError"]
torsionAngleSame <- trialBoth2["torsionAngleCW"] * trialBoth2["afterReversalD"]
idx <- trialBoth2$afterReversalD * trialBoth2$timeWindow==-1
torsionAngleSame[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
idx <- trialBoth2$timeWindow==0 & trialBoth2$afterReversalD==1
torsionAngleSame[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
torsionAngleDiff <- trialBoth2["torsionAngleCW"] * trialBoth2["afterReversalD"]
idx <- trialBoth2$afterReversalD * trialBoth2$timeWindow==1
torsionAngleDiff[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
idx <- trialBoth2$timeWindow==0 & trialBoth2$afterReversalD==-1
torsionAngleDiff[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
dataBoth2b <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionAngleSame, torsionAngleDiff)
dataBoth2b$exp <- as.factor(dataBoth2b$exp)
dataBoth2b$sub <- as.factor(dataBoth2b$sub)
dataBoth2b$rotationSpeed <- as.factor(dataBoth2b$rotationSpeed)
# dataBoth2b$afterReversalD <- as.factor(dataBoth2b$afterReversalD)
colnames(dataBoth2b)[5] <- "torsionAngleSame"
colnames(dataBoth2b)[6] <- "torsionAngleDiff"

conBoth2 <- aggregate(torsionAngleSame ~ sub * exp * rotationSpeed,
    data = dataBoth2b, FUN = "mean")
colnames(conBoth2)[4] <- "torsionAngleSame"
# conBoth2$torsionAngleSame <- abs(conBoth2$torsionAngleSame)

torsionABoth2Anova <- ezANOVA(conBoth2, dv = .(torsionAngleSame), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionABoth2Anova)
#
# postTime <- ezStats(conBoth2, dv = .(torsionAngleSame), wid = .(sub), within = .(timeWindow))
# print(postTime)

# pdf("torsionAngleSameBothExp2_interaction3.pdf")
p <- ggplot(conBoth2, aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD,
    group = afterReversalD)) + stat_summary(fun.data = mean_se, geom = "errorbar",
    width = 0.2) + geom_line(stat = "summary", fun.y = "mean")
print(p)
# dev.off()

# correlation
conCorBoth2 <- aggregate(cbind(torsionAngleSame, perceptualError) ~ sub * exp *
    rotationSpeed, data = dataBoth2b, FUN = "mean")
colnames(conCorBoth2)[4] <- "torsionAngleSameMean"
colnames(conCorBoth2)[5] <- "perceptualErrorMean"
conCorBoth2$rotationSpeed <- as.numeric(conCorBoth2$rotationSpeed)
# show(conCorBoth2$perceptualErrorMean)

corExp2 <- pcor.test(conCorBoth2$perceptualErrorMean, conCorBoth2$torsionAngleSameMean,
    conCorBoth2$rotationSpeed, method = c("pearson"))
print(corExp2)

# after reversal
trialBoth2 <- trialDataBoth2Original[which(trialDataBoth2Original$timeWindow == 1), ]
sub <- trialBoth2["sub"] + 20
exp <- trialBoth2["exp"]
# afterReversalD <- trialBoth2["afterReversalD"]
rotationSpeed <- trialBoth2["rotationSpeed"]
perceptualError <- trialBoth2["perceptualError"]
torsionAngleSame <- trialBoth2["torsionAngleCW"] * trialBoth2["afterReversalD"]
idx <- trialBoth2$afterReversalD * trialBoth2$timeWindow==-1
torsionAngleSame[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
idx <- trialBoth2$timeWindow==0 & trialBoth2$afterReversalD==1
torsionAngleSame[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
torsionAngleDiff <- trialBoth2["torsionAngleCW"] * trialBoth2["afterReversalD"]
idx <- trialBoth2$afterReversalD * trialBoth2$timeWindow==1
torsionAngleDiff[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
idx <- trialBoth2$timeWindow==0 & trialBoth2$afterReversalD==-1
torsionAngleDiff[idx, ] <- trialBoth2$torsionAngleCCW[idx] * trialBoth2$afterReversalD[idx]
dataBoth2a <- data.frame(sub, exp, rotationSpeed, perceptualError, torsionAngleSame, torsionAngleDiff)
dataBoth2a$exp <- as.factor(dataBoth2a$exp)
dataBoth2a$sub <- as.factor(dataBoth2a$sub)
dataBoth2a$rotationSpeed <- as.factor(dataBoth2a$rotationSpeed)
# dataBoth2a$afterReversalD <- as.factor(dataBoth2a$afterReversalD)
colnames(dataBoth2a)[5] <- "torsionAngleSame"
colnames(dataBoth2a)[6] <- "torsionAngleDiff"

conBoth2 <- aggregate(torsionAngleSame ~ sub * exp * rotationSpeed,
    data = dataBoth2a, FUN = "mean")
colnames(conBoth2)[4] <- "torsionAngleSame"

torsionABoth2Anova <- ezANOVA(conBoth2, dv = .(torsionAngleSame), wid = .(sub), within = .(rotationSpeed), type = 3)
print(torsionABoth2Anova)

p <- ggplot(conBoth2, aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD,
    group = afterReversalD)) + stat_summary(fun.data = mean_se, geom = "errorbar",
    width = 0.2) + geom_line(stat = "summary", fun.y = "mean")
print(p)

# correlation
conCorBoth2 <- aggregate(cbind(torsionAngleSame, perceptualError) ~ sub * exp *
    rotationSpeed, data = dataBoth2a, FUN = "mean")
colnames(conCorBoth2)[4] <- "torsionAngleSameMean"
colnames(conCorBoth2)[5] <- "perceptualErrorMean"
conCorBoth2$rotationSpeed <- as.numeric(conCorBoth2$rotationSpeed)
# show(conCorBoth2$perceptualErrorMean)

corExp2 <- pcor.test(conCorBoth2$perceptualErrorMean, conCorBoth2$torsionAngleSameMean,
    conCorBoth2$rotationSpeed, method = c("pearson"))
print(corExp2)
