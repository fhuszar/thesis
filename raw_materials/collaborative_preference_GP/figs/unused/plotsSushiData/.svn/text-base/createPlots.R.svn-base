
nExperiments <- 10
nRepetitions <- 25

# We load the error values of the single task approach

errorGPCbald <- matrix(0, nRepetitions, nExperiments + 1)
errorGPCentropy <- matrix(0, nRepetitions, nExperiments + 1)
errorGPCrandom <- matrix(0, nRepetitions, nExperiments + 1)
for (i in 0 : nExperiments) {
	for (j in 1 : nRepetitions) {
		errorGPCbald[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epGPCbald/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
		errorGPCentropy[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epGPCentropy/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
		errorGPCrandom[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epGPCrandom/simulation", j, "/results/error", i, ".txt", sep = ""))$V1

	}
}

# We load the error values of the multi-task approach

errorMPLbald <- matrix(0, nRepetitions, nExperiments + 1)
errorMPLentropy <- matrix(0, nRepetitions, nExperiments + 1)
errorMPLrandom <- matrix(0, nRepetitions, nExperiments + 1)
for (i in 0 : nExperiments) {
	for (j in 1 : nRepetitions) {
		errorMPLbald[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epMPLbald/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
		errorMPLentropy[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epMPLentropy/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
		errorMPLrandom[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epMPLrandom/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
	}
}

# We load the error values for the Birlutiu approach

errorMPLbaldBirlutiu <- matrix(0, nRepetitions, nExperiments + 1)
errorMPLentropyBirlutiu <- matrix(0, nRepetitions, nExperiments + 1)
errorMPLrandomBirlutiu <- matrix(0, nRepetitions, nExperiments + 1)
for (i in 0 : nExperiments) {
	for (j in 1 : nRepetitions) {
		errorMPLbaldBirlutiu[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epMPLbaldBirlutiu/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
		errorMPLentropyBirlutiu[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epMPLentropyBirlutiu/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
		errorMPLrandomBirlutiu[ j, i + 1 ] <- read.table(paste("/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning",
			"/activeLearningNewVersion/sushiDataset/epMPLrandomBirlutiu/simulation", j, "/results/error", i, ".txt", sep = ""))$V1
	}
}

# We plot the data

pdf("plotSushiDatasetSTvsMT.pdf", width = 7.5, height = 7.5)
par(cex = 1.3)
plot(seq(0, 10), apply(errorGPCbald, 2, mean), lwd = 3, lty = 1, col = "black", type = "l",
	main = "Sushi Dataset. MT vs. ST", xlab = "Number of Active Measurements", ylab = "Average Test Error", ylim = c(0.11, 0.255))
lines(seq(0, 10), apply(errorGPCentropy, 2, mean), lwd = 3, lty = 2, col = "black")
lines(seq(0, 10), apply(errorGPCrandom, 2, mean), lwd = 3, lty = 3, col = "black")

lines(seq(0, 10), apply(errorMPLbald, 2, mean), lwd = 3, lty = 1, col = "red")
lines(seq(0, 10), apply(errorMPLentropy, 2, mean), lwd = 3, lty = 2, col = "red")
lines(seq(0, 10), apply(errorMPLrandom, 2, mean), lwd = 3, lty = 3, col = "red")

legend("topright", c("ST-B", "ST-E", "ST-R", "MT-B", "MT-E", "MT-R"), lwd = c(3, 3, 3, 3, 3, 3),
	col = c("black", "black", "black", "red", "red", "red"), lty = c(1, 2, 3, 1, 2, 3))
dev.off(2)

# We plot the data

pdf("plotSushiDatasetMBvsMT.pdf", width = 7.5, height = 7.5)
par(cex = 1.3)
plot(seq(0, 10), apply(errorMPLbaldBirlutiu, 2, mean), lwd = 3, lty = 1, col = "black", type = "l",
	main = "Sushi Dataset. MT vs. MB", xlab = "Number of Active Measurements", ylab = "Average Test Error", ylim = c(0.11, 0.27))
lines(seq(0, 10), apply(errorMPLentropyBirlutiu, 2, mean), lwd = 3, lty = 2, col = "black")
lines(seq(0, 10), apply(errorMPLrandomBirlutiu, 2, mean), lwd = 3, lty = 3, col = "black")

lines(seq(0, 10), apply(errorMPLbald, 2, mean), lwd = 3, lty = 1, col = "red")
lines(seq(0, 10), apply(errorMPLentropy, 2, mean), lwd = 3, lty = 2, col = "red")
lines(seq(0, 10), apply(errorMPLrandom, 2, mean), lwd = 3, lty = 3, col = "red")

legend("topright", c("MB-B", "MB-E", "MB-R", "MT-B", "MT-E", "MT-R"), lwd = c(3, 3, 3, 3, 3, 3),
	col = c("black", "black", "black", "red", "red", "red"), lty = c(1, 2, 3, 1, 2, 3))
dev.off(2)
