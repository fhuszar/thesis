
generateTable <- function(methodsFolders, methodsNames, nMeasurements) {

	fileName <- paste("tableSushi.tex", sep = "")

	auxString <- c()
	for (i in 1 : length(methodsNames))
		auxString <- paste(auxString, "@{\\hspace{0.2cm}}r@{$\\pm$}l", sep = "")

	system(paste("rm -f ", fileName, sep = ""))

	cat("\\begin{table}\n", file = fileName, append = T)
	cat("\\centering\n", file = fileName, append = T)
	cat(paste("\\caption{Results for the Sushi dataset.}\n"), file = fileName, append = T)
	cat("\\label{tab:resultsSushi}\n", file = fileName, append = T)

	cat("\\resizebox{\\textwidth}{!}{\n", file = fileName, append = T)
	cat(paste("\\begin{tabular}{c", auxString, "}", sep = ""), file = fileName, append = T)
	cat("\n\\hline\n", file = fileName, append = T)
	cat("\\bf{ $\\bm n$}", file = fileName, append = T)

	for (i in 1 : length(methodsNames))
		cat("& \\multicolumn{2}{c}{ \\bf{", methodsNames[ i ], "}}", file = fileName, append = T)

	cat("\\\\\n\\hline\n", file = fileName, append = T)

	for (i in 1 : length(nMeasurements)) {
		cat(nMeasurements[ i ], file = fileName, append = T)

		# We obtain the errors

		nSimulations <- 25
		error <- matrix(0, nSimulations, length(methodsNames))
		for (j in 1 : length(methodsFolders)) {
			for (k in 1 : nSimulations) {
				error[ k, j ] <- read.table(paste(methodsFolders[ j ],
				"simulation", k, "/results/error", nMeasurements[ i ], ".txt", sep = ""))$V1
			}
		}

		# We select the best method

		index <- which.min(apply(error,2,mean))

		for (j in 1 : length(methodsFolders)) {
			error <- c()
			for (k in 1 : 25)
				error <- c(error, read.table(paste(methodsFolders[ j ],
					"simulation", k, "/results/error", nMeasurements[ i ], ".txt", sep = ""))$V1)

			if (j == index) {
				cat("&", "\\bf{", formatC(mean(100 * error), digits = 2, format = "f"), "} & \\bf{", formatC(sd(100 * error),
					digits = 1, format = "f"), "}", sep = "", file = fileName, append = T)
			} else {
				cat("&", formatC(mean(100 * error), digits = 2, format = "f"), "&", formatC(sd(100 * error),
					digits = 1, format = "f"), file = fileName, append = T)
			}
		}

		cat("\\\\\n", file = fileName, append = T)
	}

	cat("\n\\hline\n", file = fileName, append = T)

	cat("\\end{tabular}\n", file = fileName, append = T)
	cat("}\n", file = fileName, append = T)
	cat("\\end{table}\n", file = fileName, append = T)
}

nMeasurements <- c(0, 3, 5, 7, 10)

methodsFolders <- c(
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epMPLbald/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epMPLentropy/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epMPLrandom/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epGPCbald/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epGPCentropy/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epGPCrandom/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epMPLbaldBirlutiu/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epMPLentropyBirlutiu/",
	"/home/miguel/projects/multiTaskPreferenceLearning/multiTaskPreferenceLearning/activeLearningNewVersion/sushiDataset/epMPLrandomBirlutiu/")

methodsNames <- c("MT-B", "MT-E", "MT-R", "ST-B", "ST-E", "ST-R", "MB-B", "MB-E", "MB-R")

generateTable(methodsFolders, methodsNames, nMeasurements)
