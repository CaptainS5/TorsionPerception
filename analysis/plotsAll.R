library(ggplot2)
library(RColorBrewer)
# library(matrixStats)
library(ppcor)
# library(reshape)

#### clear environment
rm(list = ls())

#### load data
# # on ASUS
# setwd("E:/XiuyunWu/Torsion-FDE/analysis")
# folder1 <- ("E:/XiuyunWu/Torsion-FDE/figures/Exp1/")
# folder2 <- ("E:/XiuyunWu/Torsion-FDE/figures/Exp2/")
# on XPS13
setwd("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/analysis")
folder1 <- ("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/results/figures/Exp1/")
folder2 <- ("C:/Users/CaptainS5/Documents/PhD@UBC/Lab/1st year/TorsionPerception/results/figures/Exp2/")
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
baseTorsion1Original <- read.csv("trialDataBaseAllExp1.csv")
baseTorsion2Original <- read.csv("trialDataBaseAllExp2.csv")
trialData1Original <- read.csv("trialDataAllExp1.csv")
trialData2Original <- read.csv("trialDataAllExp2.csv")
trialDataBoth2Original <- read.csv("trialDataAllBothEyeExp2.csv")
# eye: 1 left eye, 2 right eye
# afterReversalD: -1 CCW, 1 CW, 0 merged as CW
# time window: -1 120ms after onset to flash onset; 0-flash onset to flash offset; 1 120ms after flash offset to end
tw <- c(-1, 0, 1)
endName <- c("beforeReversal", "atReversal", "afterReversal")

# parameters for plotting
# for the poster
# lindWidth <- 1.5
# dotSize <- 3
# dotCorSize <- 6
# dotCorAlpha <- 0.8
# for manuscript
lindWidth <- 1.5
dotSize <- 2
dotCorSize <- 4
dotCorAlpha <- 0.8
textSize <- 15
vtPlotWidth <- 16 # pdf figure width for velocity traces

#### perceptual data
### Exp1
trialData1 <- trialData1Original[which(trialData1Original$timeWindow == 1), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
perceptualError <- trialData1["perceptualError"]
dataExp1 <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualError)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)

dataAgg1 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1, FUN = "mean")
dataAgg1$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1, FUN = "sd")$perceptualError

pdf(paste(folder1,"perceptionExp1.pdf", sep = ""))
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = perceptualError, colour = afterReversalD, group = afterReversalD)) +
        stat_summary(aes(y = perceptualError, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth) +
        stat_summary(fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        # geom_boxplot(aes(x = rotationSpeed, y = perceptualError), size = 0.8, outlier.size = 1.5, outlier.shape = 21) +
        # geom_point(aes(x = rotationSpeed, y = perceptualError, group = afterReversalD), size = dotSize, position = position_jitterdodge(), shape = 21) +
        coord_cartesian(ylim=c(0, 20)) +
        scale_y_continuous(name = "Illusory posotion shift (°)") +
        scale_x_continuous(name = "Rotational speed (°/s)", breaks=c(25, 50, 100, 200, 400)) +
        scale_colour_discrete(name = "After reversal\ndirection", labels = c("CCW", "CW")) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
dev.off()
ggsave(filename = paste(folder1,"perceptionExp1.eps"), plot = print(p))

#### Exp2
trialData2 <- trialData2Original[which(trialData2Original$timeWindow == 1), ]
sub <- trialData2["sub"]
exp <- trialData2["exp"]
afterReversalD <- trialData2["afterReversalD"]
rotationSpeed <- trialData2["rotationSpeed"]
perceptualError <- trialData2["perceptualError"]
dataExp2 <- data.frame(sub, exp, afterReversalD, rotationSpeed, perceptualError)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)

dataAgg2 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp2, FUN = "mean")
dataAgg2$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp2, FUN = "sd")$perceptualError

pdf(paste(folder2, "perceptionExp2.pdf", sep = ""))
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = perceptualError, colour = afterReversalD, group = afterReversalD)) +
        stat_summary(aes(y = perceptualError, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth) +
        stat_summary(fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        # geom_boxplot(aes(x = rotationSpeed, y = perceptualError, colour = afterReversalD), position = position_dodge(width = 0.8), size = 0.8, outlier.size = 1.5, outlier.shape = 21) +
        # geom_point(aes(x = rotationSpeed, y = perceptualError, colour = afterReversalD), size = dotSize, position = position_jitterdodge(), shape = 21) +
        coord_cartesian(ylim=c(0, 20)) +
        scale_y_continuous(name = "Illusory posotion shift (°)") +
        scale_x_continuous(name = "Rotational speed (°/s)", breaks=c(25, 50, 100, 200)) +
        scale_colour_discrete(name = "After reversal\ndirection", labels = c("CCW", "CW")) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
dev.off()

#### Torsion data, baseline, experiment, and correlation
### Exp1
## baseline
# mean velocity traces
# first get mean for each speed and the confidence intervals
speedName <-c("25", "50", "100", "200", "400")
n <- 15
timePoints <- seq(from = 0, to = 2115, by = 5)
velTrace <- list()
for (speed in 1:5) {
    fileName = paste("velocityTraceExp1_base_",speedName[speed],".csv", sep = "")
    velData <- read.csv(fileName, header = FALSE, sep=",")
    velData <- as.matrix(velData)
    velData <- velData[, 1:424]

    tempM <- colMeans(velData, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velData, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
colourCode <- brewer.pal(n = 5, name = "Accent")

# plot velocity traces with 95% CI
# pdf(paste(folder1, "velocityTraces.pdf", sep = ""))
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        geom_line(data = velTrace[[5]], aes(x = timePoints, y = velMean, colour = "s400"), size = 1) + geom_ribbon(data = velTrace[[5]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s400"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-3, 4, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(0, 2200, 100)) +
        # coord_cartesian(ylim=c(-2, 3)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200", "s400"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4], "s400" = colourCode[5])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
# dev.off()
ggsave(paste(folder1, "velocityTraces_baseExp1.pdf", sep = ""), width = vtPlotWidth)

# torsional velocity
trialData1 <- baseTorsion1Original
sub <- trialData1["sub"]
exp <- trialData1["exp"]
afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
torsionVelT <- trialData1["torsionVelT"] * trialData1["afterReversalD"]
dataExp1 <- data.frame(sub, exp, afterReversalD, rotationSpeed, torsionVelT)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)

dataAgg1 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1, FUN = "mean")
dataAgg1$tsd <- aggregate(torsionVelT ~ rotationSpeed * afterReversalD * exp * sub, data = dataExp1, FUN = "sd")$torsionVelT

pdf(paste(folder1, "torsionVExp1Base.pdf", sep = ""))
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD, group = interaction(rotationSpeed, afterReversalD))) +
        stat_summary(fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        stat_summary(aes(y = torsionVelT, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth) +
        # geom_boxplot(aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD, group = interaction(rotationSpeed, afterReversalD)), position = position_dodge(width = 0.8), size = 0.8, outlier.size = 1.5, outlier.shape = 21) +
        # geom_point(aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD), size = dotSize, position = position_jitterdodge(), shape = 21) +
        coord_cartesian(ylim=c(0, 2)) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Rotational speed (°/s)", breaks=c(25, 100, 200, 400)) +
        scale_colour_discrete(name = "After-reversal\ndirection", labels = c("CCW", "CW")) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
dev.off()

## experiement
# mean velocity traces
# first get mean for each speed and the confidence intervals
speedName <-c("25", "50", "100", "200", "400")
n <- 15
timePoints <- seq(from = -835, to = 740, by = 5) # originally from -845 to 750 ms, reversal onset is 0 ms
# delete the extreme time points when data are really noisy...
velTrace <- list()
for (speed in 1:5) {
    fileName = paste("velocityTraceExp1_",speedName[speed],".csv", sep = "")
    velData <- read.csv(fileName, header = FALSE, sep=",")
    velData <- as.matrix(velData)
    velData <- velData[, 3:318]

    tempM <- colMeans(velData, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velData, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
colourCode <- brewer.pal(n = 5, name = "Accent")

# plot velocity traces with 95% CI
# pdf(paste(folder1, "velocityTraces.pdf", sep = ""))
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        geom_line(data = velTrace[[5]], aes(x = timePoints, y = velMean, colour = "s400"), size = 1) + geom_ribbon(data = velTrace[[5]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s400"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(-700, 700, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200", "s400"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4], "s400" = colourCode[5])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
# dev.off()
ggsave(paste(folder1, "velocityTraces.pdf", sep = ""), width = vtPlotWidth)

# torsion velocity
trialData1 <- trialData1Original #[which(trialData1Original$timeWindow != 0), ]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
timeWindow <- trialData1["timeWindow"]
perceptualError <- trialData1["perceptualError"]
torsionVelT <- trialData1["torsionVelT"] * trialData1["afterReversalD"]
dataExp1 <- data.frame(sub, exp, afterReversalD, rotationSpeed, timeWindow, perceptualError, torsionVelT)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$timeWindow <- as.factor(dataExp1$timeWindow)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)

dataAgg1 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp1, FUN = "mean")
dataAgg1$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp1, FUN = "sd")$perceptualError
dataAgg1$tsd <- aggregate(torsionVelT ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp1, FUN = "sd")$torsionVelT
levels(dataAgg1$timeWindow) <- c("Before reversal", "At reversal", "After reversal")

pdf(paste(folder1, "torsionVExp1.pdf", sep = ""))
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD, group = interaction(rotationSpeed, afterReversalD))) +
        stat_summary(fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        stat_summary(aes(y = torsionVelT, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth) +
        # geom_boxplot(aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD, group = interaction(rotationSpeed, afterReversalD)), position = position_dodge(width = 0.8), size = 0.8, outlier.size = 1.5, outlier.shape = 21) +
        # geom_point(aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD), size = dotSize, position = position_jitterdodge(), shape = 21) +
        coord_cartesian(ylim=c(-2, 2)) +
        geom_hline(yintercept=0, linetype="dotted", color = "black") +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Rotational speed (°/s)", breaks=c(25, 100, 200, 400)) +
        scale_colour_discrete(name = "After-reversal\ndirection", labels = c("CCW", "CW")) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white")) +
              facet_wrap(~timeWindow)
print(p)
dev.off()

# correlation of velocity
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)
dataAgg1 <- aggregate(. ~ rotationSpeed * exp * sub * timeWindow, data = dataExp1, FUN = "mean")
dataAgg1$psd <- aggregate(perceptualError ~ rotationSpeed * exp * sub * timeWindow, data = dataExp1, FUN = "sd")$perceptualError
dataAgg1$tsd <- aggregate(torsionVelT ~ rotationSpeed * exp * sub * timeWindow, data = dataExp1, FUN = "sd")$torsionVelT
levels(dataAgg1$timeWindow) <- c(-1, 0, 1)

twN <- c("beforeReversal", "atReversal", "afterReversal")
twValues <- c(-1, 0, 1)
for (tw in 1:3) {
    dataAgg1sub <- dataAgg1[which(dataAgg1$timeWindow==twValues[tw]), ]
    pdf(paste(folder1, "correlationVelExp1_", twN[tw], ".pdf", sep = ""))
    p <- ggplot(dataAgg1sub, aes(x = perceptualError, y = torsionVelT, fill = rotationSpeed)) +
            geom_point(size = dotCorSize, shape = 23, alpha = dotCorAlpha) +
            scale_fill_brewer(palette="Accent", name = "Rotational\nspeed (°/s)") +
            scale_y_continuous(name = "Torsional velocity (°/s)") +
            scale_x_continuous(name = "Illusory position shift (°)") +
            theme(axis.line = element_line(colour = "black", size = 0.5),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  text = element_text(size = textSize),
                  legend.background = element_rect(fill="transparent"),
                  legend.key = element_rect(colour = "transparent", fill = "white"),
                  aspect.ratio=1)
    print(p)
    dev.off()
    dataAgg1sub$perceptualError <- as.numeric(dataAgg1sub$perceptualError)
    dataAgg1sub$torsionVelT <- as.numeric(dataAgg1sub$torsionVelT)
    dataAgg1sub$rotationSpeed <- as.numeric(dataAgg1sub$rotationSpeed)
    corExp1BR <- pcor.test(dataAgg1sub$perceptualError, dataAgg1sub$torsionVelT, dataAgg1sub$rotationSpeed,
        method = c("pearson"))
    print(corExp1BR)
}

# torsion angle, in the direction of afterReversalD, merged to always CW after reversal (just similar to VelT)
trialData1 <- trialData1Original
trialData1["torsionAngleCCW"] <- -trialData1["torsionAngleCCW"]
sub <- trialData1["sub"]
exp <- trialData1["exp"]
afterReversalD <- trialData1["afterReversalD"]
rotationSpeed <- trialData1["rotationSpeed"]
timeWindow <- trialData1["timeWindow"]
perceptualError <- trialData1["perceptualError"]
torsionAngleSame <- trialData1["torsionAngleCW"] * trialData1["afterReversalD"]
idx <- trialData1$afterReversalD * trialData1$timeWindow==-1
torsionAngleSame[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
idx <- which(trialData1$timeWindow==0 & trialData1$afterReversalD==1)
torsionAngleSame[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
torsionAngleDiff <- trialData1["torsionAngleCW"] * trialData1["afterReversalD"]
idx <- trialData1$afterReversalD * trialData1$timeWindow==1
torsionAngleDiff[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]
idx <- which(trialData1$timeWindow==0 & trialData1$afterReversalD==-1)
torsionAngleDiff[idx, ] <- trialData1$torsionAngleCCW[idx] * trialData1$afterReversalD[idx]

dataExp1 <- data.frame(sub, exp, afterReversalD, rotationSpeed, timeWindow, perceptualError, torsionAngleSame, torsionAngleDiff)
dataExp1$exp <- as.factor(dataExp1$exp)
dataExp1$sub <- as.factor(dataExp1$sub)
dataExp1$timeWindow <- as.factor(dataExp1$timeWindow)
dataExp1$afterReversalD <- as.factor(dataExp1$afterReversalD)
colnames(dataExp1)[7] <- "torsionAngleSame"
colnames(dataExp1)[8] <- "torsionAngleDiff"

dataAgg1 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp1, FUN = "mean")
dataAgg1$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp1, FUN = "sd")$perceptualError

pdf(paste(folder1, "torsionAngleExp1.pdf", sep = ""))
p <- ggplot(dataAgg1, aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD, group = afterReversalD)) +
        stat_summary(fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        stat_summary(aes(y = torsionAngleSame, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth) +
        stat_summary(aes(y = torsionAngleDiff, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth, linetype = "dashed") +
        stat_summary(aes(y = torsionAngleDiff, colour = afterReversalD, group = afterReversalD), fun.data = mean_se, geom = "errorbar", width = 10, size = 1, linetype = "dashed") +
        # geom_boxplot(aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD), position = position_dodge(width = 0.8), size = 0.8, outlier.size = 1.5, outlier.shape = 21) +
        # geom_point(aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD), size = dotSize, position = position_jitterdodge(), shape = 21) +
        scale_y_continuous(breaks=seq(-1, 1, 0.5)) +
        scale_x_continuous(breaks=c(25, 50, 100, 200, 400)) +
        coord_cartesian(ylim=c(-1, 1)) +
        geom_hline(yintercept=0, linetype="dotted", color = "black") +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white")) +
              facet_wrap(~timeWindow)
print(p)
dev.off()

# correlation of angle
dataExp1$rotationSpeed <- as.factor(dataExp1$rotationSpeed)
dataAgg1 <- aggregate(. ~ rotationSpeed * exp * sub * timeWindow, data = dataExp1, FUN = "mean")

twN <- c("beforeReversal", "atReversal", "afterReversal")
twValues <- c(-1, 0, 1)
for (tw in 1:3) {
    dataAgg1sub <- dataAgg1[which(dataAgg1$timeWindow==twValues[tw]), ]
    pdf(paste(folder1, "correlationAngleExp1_", twN[tw], ".pdf", sep = ""))
    p <- ggplot(dataAgg1sub, aes(x = perceptualError, y = torsionAngleSame, fill = rotationSpeed)) +
            geom_point(size = dotCorSize, shape = 23, alpha = dotCorAlpha) +
            scale_fill_brewer(palette="Accent") +
            theme(axis.line = element_line(colour = "black", size = 0.5),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  legend.background = element_rect(fill="transparent"),
                  legend.key = element_rect(colour = "transparent", fill = "white"),
                  aspect.ratio=1) +
                  facet_wrap(~timeWindow)
    print(p)
    dev.off()
    dataAgg1sub$perceptualError <- as.numeric(dataAgg1sub$perceptualError)
    dataAgg1sub$torsionVelT <- as.numeric(dataAgg1sub$torsionAngleSame)
    dataAgg1sub$rotationSpeed <- as.numeric(dataAgg1sub$rotationSpeed)
    corExp1BR <- pcor.test(dataAgg1sub$perceptualError, dataAgg1sub$torsionAngleSame, dataAgg1sub$rotationSpeed,
        method = c("pearson"))
    print(corExp1BR)
}

### Exp2
## baseline
# mean velocity traces
# left eye
speedName <-c("25", "50", "100", "200")
n <- 10
timePoints <- seq(from = 0, to = 2080, by = 5) # originally from -870 to 750 ms, reversal onset is 0 ms
# delete the extreme time points when data are really noisy...
colourCode <- brewer.pal(n = 5, name = "Accent")
# left eye
# first get mean for each speed and the confidence intervals
velTrace <- list()
for (speed in 1:4) {
    fileName = paste("velocityTraceExp2_base_L_",speedName[speed],".csv", sep = "")
    velData <- read.csv(fileName, header = FALSE, sep=",")
    velData <- as.matrix(velData)
    tempM <- colMeans(velData, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velData, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
# plot velocity traces with 95% CI
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(0, 2100, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
ggsave(paste(folder2, "velocityTraces_baseExp2_L.pdf", sep = ""), width = vtPlotWidth)

# right eye
# first get mean for each speed and the confidence intervals
velTrace <- list()
for (speed in 1:4) {
    fileName = paste("velocityTraceExp2_base_R_",speedName[speed],".csv", sep = "")
    velData <- read.csv(fileName, header = FALSE, sep=",")
    velData <- as.matrix(velData)
    tempM <- colMeans(velData, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velData, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
# plot velocity traces with 95% CI
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(0, 2100, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
ggsave(paste(folder2, "velocityTraces_baseExp2_R.pdf", sep = ""), width = vtPlotWidth)

# difference of the two eyes--calculated in each trial
velTrace <- list()
for (speed in 1:4) {
    fileNameL = paste("velocityTraceExp2_base_L_",speedName[speed],".csv", sep = "")
    fileNameR = paste("velocityTraceExp2_base_R_",speedName[speed],".csv", sep = "")
    velDataL <- read.csv(fileNameL, header = FALSE, sep=",")
    velDataL <- as.matrix(velDataL)
    velDataR <- read.csv(fileNameR, header = FALSE, sep=",")
    velDataR <- as.matrix(velDataR)
    tempM <- colMeans(velDataL-velDataR, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velDataL-velDataR, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
# plot velocity traces with 95% CI
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(0, 2100, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
ggsave(paste(folder2, "velocityTraces_baseExp2_diffEye.pdf", sep = ""), width = vtPlotWidth)

# torsional velocity
sub <- baseTorsion2Original["sub"] + 20
rotationSpeed <- baseTorsion2Original["rotationSpeed"]
LtorsionVelT <- baseTorsion2Original["LtorsionVelT"]
RtorsionVelT <- baseTorsion2Original["RtorsionVelT"]
trialBase <- data.frame(sub, rotationSpeed, LtorsionVelT, RtorsionVelT)
trialBase$sub <- as.factor(trialBase$sub)
trialBase$rotationSpeed <- as.factor(trialBase$rotationSpeed)
trialCor <- trialBase[complete.cases(trialBase), ]

# correlation between the two eyes
pdf(paste(folder2, "correlationBaseTwoEyes.pdf", sep = ""))
p <- ggplot(trialCor, aes(x = LtorsionVelT, y = RtorsionVelT, fill = rotationSpeed)) +
    geom_point(size = dotCorSize, shape = 23, alpha = dotCorAlpha) +
    scale_y_continuous(name = "Right eye torsional velocity (°/s)") +
    scale_x_continuous(name = "Left eye torsional velocity (°/s)") +
    scale_fill_brewer(palette="Accent", name = "Rotational\nspeed (°/s)") +
    theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"),
              aspect.ratio=1)
print(p)
dev.off()

# histogram of velocity in each eye
pdf(paste(folder2, "baselineVelocityLeftEye.pdf", sep = ""))
p <- ggplot(trialCor, aes(LtorsionVelT, colour = sub)) +
        geom_density(size = 1) +
        scale_y_continuous(name = "Density") +
        scale_x_continuous(name = "Left eye torsional velocity (°/s)") +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"),
              aspect.ratio=1)
        # facet_wrap(~rotationSpeed)
print(p)
dev.off()

pdf(paste(folder2, "baselineVelocityRightEye.pdf", sep = ""))
p <- ggplot(trialCor, aes(RtorsionVelT, colour = sub)) +
        geom_density(size = 1) +
        scale_y_continuous(name = "Density") +
        scale_x_continuous(name = "Right eye torsional velocity (°/s)") +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"),
              aspect.ratio=1)
        # facet_wrap(~rotationSpeed)
print(p)
dev.off()

## experiment
sub <- trialData2Original["sub"] + 20
rotationSpeed <- trialData2Original["rotationSpeed"]
afterReversalD <- trialData2Original["afterReversalD"]
timeWindow <- trialData2Original["timeWindow"]
LtorsionVelT <- trialData2Original["LtorsionVelT"]
RtorsionVelT <- trialData2Original["RtorsionVelT"]
trialExpOriginal <- data.frame(sub, rotationSpeed, afterReversalD, timeWindow, LtorsionVelT,
    RtorsionVelT)
trialExpOriginal$sub <- as.factor(trialExpOriginal$sub)

# histogram of velocity in each eye
for (endN in 1:3) {
trialExp <- trialExpOriginal[which(trialExpOriginal$timeWindow == tw[endN] &
        abs(trialExpOriginal$LtorsionVelT) < 6), ]
trialExpCor <- trialExp[complete.cases(trialExp), ]
pdf(paste(folder2, "expVelocityLeft", endName[endN], "Eye.pdf", sep = ""))
p <- ggplot(trialExpCor, aes(LtorsionVelT, colour = sub)) +
        geom_density(size = 1) +
        scale_y_continuous(name = "Density") +
        scale_x_continuous(name = "Left eye torsional velocity (°/s)") +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"),
              aspect.ratio=1) +
        facet_wrap(~rotationSpeed)
print(p)
dev.off()

pdf(paste(folder2, "expVelocityRightEye", endName[endN], ".pdf", sep = ""))
p <- ggplot(trialExpCor, aes(RtorsionVelT, colour = sub)) +
        geom_density(size = 1) +
        scale_y_continuous(name = "Density") +
        scale_x_continuous(name = "Right eye torsional velocity (°/s)") +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"),
              aspect.ratio=1) +
        facet_wrap(~rotationSpeed)
print(p)
dev.off()
}

# mean velocity traces
speedName <-c("25", "50", "100", "200")
n <- 10
timePoints <- seq(from = -860, to = 740, by = 5) # originally from -870 to 750 ms, reversal onset is 0 ms
# delete the extreme time points when data are really noisy...
colourCode <- brewer.pal(n = 5, name = "Accent")
# left eye
# first get mean for each speed and the confidence intervals
velTrace <- list()
for (speed in 1:4) {
    fileName = paste("velocityTraceExp2_L_",speedName[speed],".csv", sep = "")
    velData <- read.csv(fileName, header = FALSE, sep=",")
    velData <- as.matrix(velData)
    velData <- velData[, 3:323]

    tempM <- colMeans(velData, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velData, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
# plot velocity traces with 95% CI
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(-700, 700, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
ggsave(paste(folder2, "velocityTraces_L.pdf", sep = ""), width = vtPlotWidth)

# right eye
# first get mean for each speed and the confidence intervals
velTrace <- list()
for (speed in 1:4) {
    fileName = paste("velocityTraceExp2_R_",speedName[speed],".csv", sep = "")
    velData <- read.csv(fileName, header = FALSE, sep=",")
    velData <- as.matrix(velData)
    velData <- velData[, 3:323]

    tempM <- colMeans(velData, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velData, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
# plot velocity traces with 95% CI
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(-700, 700, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
ggsave(paste(folder2, "velocityTraces_R.pdf", sep = ""), width = vtPlotWidth)

# difference of the two eyes
velTrace <- list()
for (speed in 1:4) {
    fileNameL = paste("velocityTraceExp2_L_",speedName[speed],".csv", sep = "")
    velDataL <- read.csv(fileNameL, header = FALSE, sep=",")
    velDataL <- as.matrix(velDataL)
    velDataL <- velDataL[, 3:323]
    fileNameR = paste("velocityTraceExp2_R_",speedName[speed],".csv", sep = "")
    velDataR <- read.csv(fileNameR, header = FALSE, sep=",")
    velDataR <- as.matrix(velDataR)
    velDataR <- velDataR[, 3:323]

    tempM <- colMeans(velDataL-velDataR, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velDataL-velDataR, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
# plot velocity traces with 95% CI
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(-700, 700, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
ggsave(paste(folder2, "velocityTraces_Exp2_diffEye.pdf", sep = ""), width = vtPlotWidth)

# both eyes
# mean velocity traces
speedName <-c("25", "50", "100", "200")
n <- 10
timePoints <- seq(from = -860, to = 740, by = 5) # originally from -870 to 750 ms, reversal onset is 0 ms
# delete the extreme time points when data are really noisy...
colourCode <- brewer.pal(n = 5, name = "Accent")
# left eye
# first get mean for each speed and the confidence intervals
velTrace <- list()
for (speed in 1:4) {
    fileName = paste("velocityTraceExp2_bothEye_",speedName[speed],".csv", sep = "")
    velData <- read.csv(fileName, header = FALSE, sep=",")
    velData <- as.matrix(velData)
    velData <- velData[, 3:323]
    tempM <- colMeans(velData, na.rm=TRUE)
    velMean <- as.matrix(tempM)

    velStd <- colSds(velData, na.rm=TRUE)

    error <- qt(0.975, df=n-1)*velStd/sqrt(n)
    velLower <- tempM-error
    velUpper <- tempM+error

    velTrace[[speed]] <- data.frame(timePoints, velMean, velLower, velUpper)
}
# plot velocity traces with 95% CI
p <- ggplot(velTrace[[1]], aes(x = timePoints, y = velMean)) +
        geom_line(aes(colour = "s25"), size = 1) + geom_ribbon(aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s25"), alpha = 0.2) +
        geom_line(data = velTrace[[2]], aes(x = timePoints, y = velMean, colour = "s50"), size = 1) + geom_ribbon(data = velTrace[[2]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s50"), alpha = 0.2) +
        geom_line(data = velTrace[[3]], aes(x = timePoints, y = velMean, colour = "s100"), size = 1) + geom_ribbon(data = velTrace[[3]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s100"), alpha = 0.2) +
        geom_line(data = velTrace[[4]], aes(x = timePoints, y = velMean, colour = "s200"), size = 1) + geom_ribbon(data = velTrace[[4]], aes(x = timePoints, ymin=velLower, ymax=velUpper, fill = "s200"), alpha = 0.2) +
        scale_y_continuous(name = "Torsional velocity (°/s)", breaks=seq(-2, 2, 1)) +
        scale_x_continuous(name = "Time (ms)", breaks=seq(-700, 700, 100)) +
        coord_cartesian(ylim=c(-2, 2)) +
        scale_colour_manual("Rotational speed (°/s)",
                            breaks = c("s25", "s50", "s100", "s200"),
                            values = c("s25" = colourCode[1], "s50" = colourCode[2], "s100" = colourCode[3], "s200" = colourCode[4])) +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white"))
print(p)
ggsave(paste(folder2, "velocityTraces_bothEye.pdf", sep = ""), width = vtPlotWidth)

# torsional velocity
trialData2 <- trialDataBoth2Original #[which(trialDataBoth2Original$timeWindow != 0), ]
sub <- trialData2["sub"]
exp <- trialData2["exp"]
afterReversalD <- trialData2["afterReversalD"]
rotationSpeed <- trialData2["rotationSpeed"]
timeWindow <- trialData2["timeWindow"]
perceptualError <- trialData2["perceptualError"]
torsionVelT <- trialData2["torsionVelT"] * trialData2["afterReversalD"]
dataExp2 <- data.frame(sub, exp, afterReversalD, rotationSpeed, timeWindow, perceptualError, torsionVelT)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$timeWindow <- as.factor(dataExp2$timeWindow)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)

dataAgg2 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp2, FUN = "mean")
dataAgg2$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp2, FUN = "sd")$perceptualError
dataAgg2$tsd <- aggregate(torsionVelT ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp2, FUN = "sd")$torsionVelT
levels(dataAgg2$timeWindow) <- c("Before-reversal", "At-reversal", "After-reversal")

pdf(paste(folder2, "torsionVExp2.pdf", sep = ""))
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD, group = afterReversalD)) +
        stat_summary(fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        stat_summary(aes(y = torsionVelT, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth) +
        # geom_boxplot(aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD), position = position_dodge(width = 0.8), size = 0.8, outlier.size = 1.5, outlier.shape = 21) +
        # geom_point(aes(x = rotationSpeed, y = torsionVelT, colour = afterReversalD), size = dotSize, position = position_jitterdodge(), shape = 21) +
        scale_y_continuous(breaks=seq(-2, 2, 1), name = "Torsional velocity (°/s)") +
        scale_x_continuous(breaks=c(25, 50, 100, 200), name = "Rotational speed (°/s)") +
        scale_colour_discrete(name = "After-reversal\ndirection", labels = c("CCW", "CW")) +
        coord_cartesian(ylim=c(-2, 2)) +
        geom_hline(yintercept=0, linetype="dotted", color = "black") +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white")) +
              facet_wrap(~timeWindow)
print(p)
dev.off()

# # correlation of velocity
# dataExp2$rotationSpeed <- as.factor(dataExp2$rotationSpeed)
# dataAgg2 <- aggregate(. ~ rotationSpeed * exp * sub * timeWindow, data = dataExp2, FUN = "mean")
# dataAgg2$psd <- aggregate(perceptualError ~ rotationSpeed * exp * sub * timeWindow, data = dataExp2, FUN = "sd")$perceptualError
# dataAgg2$tsd <- aggregate(torsionVelT ~ rotationSpeed * exp * sub * timeWindow, data = dataExp2, FUN = "sd")$torsionVelT
#
# twN <- c("beforeReversal", "afterReversal")
# twValues <- c(-1, 1)
# for (tw in 1:2) {
#     dataAgg2sub <- dataAgg2[which(dataAgg2$timeWindow==twValues[tw]), ]
#     pdf(paste(folder2, "correlationVelExp2_", twN[tw], ".pdf"))
#     p <- ggplot(dataAgg2sub, aes(x = perceptualError, y = torsionVelT, fill = rotationSpeed)) +
#             geom_point(size = dotCorSize, shape = 23, alpha = dotCorAlpha) +
#             scale_fill_brewer(palette="Accent") +
#             theme(axis.line = element_line(colour = "black", size = 0.5),
#                   panel.grid.major = element_blank(),
#                   panel.grid.minor = element_blank(),
#                   panel.border = element_blank(),
#                   panel.background = element_blank(),
#                   legend.background = element_rect(fill="transparent"),
#                   legend.key = element_rect(colour = "transparent", fill = "white"),
#                   aspect.ratio=1) +
#                   facet_wrap(~timeWindow)
#     print(p)
#     dev.off()
# }

# torsional angle
sub <- trialData2["sub"]
exp <- trialData2["exp"]
afterReversalD <- trialData2["afterReversalD"]
rotationSpeed <- trialData2["rotationSpeed"]
timeWindow <- trialData2["timeWindow"]
perceptualError <- trialData2["perceptualError"]
torsionAngleSame <- trialData2["torsionAngleCW"] * trialData2["afterReversalD"]
idx <- trialData2$afterReversalD * trialData2$timeWindow==-1
torsionAngleSame[idx, ] <- trialData2$torsionAngleCCW[idx] * trialData2$afterReversalD[idx]
idx <- which(trialData2$timeWindow==0 & trialData2$afterReversalD==1)
torsionAngleSame[idx, ] <- trialData2$torsionAngleCCW[idx] * trialData2$afterReversalD[idx]
torsionAngleDiff <- trialData2["torsionAngleCW"] * trialData2["afterReversalD"]
idx <- trialData2$afterReversalD * trialData2$timeWindow==1
torsionAngleDiff[idx, ] <- trialData2$torsionAngleCCW[idx] * trialData2$afterReversalD[idx]
idx <- which(trialData2$timeWindow==0 & trialData2$afterReversalD==-1)
torsionAngleDiff[idx, ] <- trialData2$torsionAngleCCW[idx] * trialData2$afterReversalD[idx]

dataExp2 <- data.frame(sub, exp, afterReversalD, rotationSpeed, timeWindow, perceptualError, torsionAngleSame, torsionAngleDiff)
dataExp2$exp <- as.factor(dataExp2$exp)
dataExp2$sub <- as.factor(dataExp2$sub)
dataExp2$timeWindow <- as.factor(dataExp2$timeWindow)
dataExp2$afterReversalD <- as.factor(dataExp2$afterReversalD)
colnames(dataExp2)[7] <- "torsionAngleSame"
colnames(dataExp2)[8] <- "torsionAngleDiff"

dataAgg2 <- aggregate(. ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp2, FUN = "mean")
dataAgg2$psd <- aggregate(perceptualError ~ rotationSpeed * afterReversalD * exp * sub * timeWindow, data = dataExp2, FUN = "sd")$perceptualError

pdf(paste(folder2, "torsionAngleExp2.pdf", sep = ""))
p <- ggplot(dataAgg2, aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD, group = afterReversalD)) +
        stat_summary(fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        stat_summary(aes(y = torsionAngleSame, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth) +
        stat_summary(aes(y = torsionAngleDiff, colour = afterReversalD, group = afterReversalD), fun.y = mean, geom = "line", size = lindWidth, linetype = "dashed") +
        stat_summary(aes(y = torsionAngleDiff, colour = afterReversalD, group = afterReversalD), fun.data = mean_se, geom = "errorbar", width = 10, size = 1) +
        # geom_boxplot(aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD), position = position_dodge(width = 0.8), size = 0.8, outlier.size = 1.5, outlier.shape = 21) +
        # geom_point(aes(x = rotationSpeed, y = torsionAngleSame, colour = afterReversalD), size = dotSize, position = position_jitterdodge(), shape = 21) +
        scale_y_continuous(breaks=seq(-1, 1, 0.5), name = "Torsional angle (°)") +
        scale_x_continuous(breaks=c(25, 50, 100, 200), name = "Rotational speed (°/s)") +
        scale_colour_discrete(name = "After-reversal\ndirection", labels = c("CCW", "CW")) +
        coord_cartesian(ylim=c(-1, 1)) +
        geom_hline(yintercept=0, linetype="dotted", color = "black") +
        theme(axis.line = element_line(colour = "black", size = 0.5),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              text = element_text(size = textSize),
              legend.background = element_rect(fill="transparent"),
              legend.key = element_rect(colour = "transparent", fill = "white")) +
              facet_wrap(~timeWindow)
print(p)
dev.off()

# # correlation of angle
# dataExp2$rotationSpeed <- as.factor(dataExp2$rotationSpeed)
# dataAgg2 <- aggregate(. ~ rotationSpeed * exp * sub * timeWindow, data = dataExp2, FUN = "mean")
#
# twN <- c("beforeReversal", "afterReversal")
# twValues <- c(-1, 1)
# for (tw in 1:2) {
#     dataAgg2sub <- dataAgg2[which(dataAgg2$timeWindow==twValues[tw]), ]
#     pdf(paste(folder2, "correlationAngleExp2_", twN[tw], ".pdf"))
#     p <- ggplot(dataAgg2sub, aes(x = perceptualError, y = torsionAngleSame, fill = rotationSpeed)) +
#             geom_point(size = dotCorSize, shape = 23, alpha = dotCorAlpha) +
#             scale_fill_brewer(palette="Accent") +
#             theme(axis.line = element_line(colour = "black", size = 0.5),
#                   panel.grid.major = element_blank(),
#                   panel.grid.minor = element_blank(),
#                   panel.border = element_blank(),
#                   panel.background = element_blank(),
#                   legend.background = element_rect(fill="transparent"),
#                   legend.key = element_rect(colour = "transparent", fill = "white"),
#                   aspect.ratio=1) +
#                   facet_wrap(~timeWindow)
#     print(p)
#     dev.off()
# }
