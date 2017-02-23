library(tidyverse)
library(stringr)
library(utiml)
library(mldr)
library(e1071)

labels <- read_csv("/home/jan/labels.csv", col_names = FALSE)
vid_ids <- read_csv("/home/jan/vid_ids.csv", col_names = FALSE)
mean_rgb <- read_csv("/home/jan/mean_rgb.csv", col_names = FALSE)
mean_audio <- read_csv("/home/jan/mean_audio.csv", col_names = FALSE)

labels_as_int <- labels$X1 %>% str_extract_all(pattern = "[0-9]+")

labels_as_int <- lapply(labels_as_int, as.numeric)

labels_mat <- data.frame(matrix(0, ncol = 5000, nrow = length(labels_as_int)))

for(i in 1:length(labels_as_int)) {
  labels_mat[i, labels_as_int[[i]] + 1] <- 1
}

full_dataset <- bind_cols(mean_audio, mean_rgb, labels_mat)

full_ds_mldr <- mldr_from_dataframe(full_dataset, labelIndices = 1153:6152, name = "YT")

#write_arff(mymldr, "my_new_mldr")

br_model <- br(full_ds_mldr, "SVM")

