---
title: "README.md"
author: "Juan Agustín Morello"
date: "July 23, 2020"
---

# Getting and Cleaning Data Course Project

## Summary (from Coursera, Johns Hopkins Data Science Specialization)

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.

## Project explanation

The dataset the script uses is explained in the `CodeBook.md` file.

The script in `run_analysis.R` can be launched in the prompt by just importing the file; or in RStudio, by loading the file and submit to source.

**Roughly speaking**, the R code does the following things:

* Merges training and test files of dataset to create an unique dataset (using `rbind` and `cbind`)
* Extracts only the mean and standard deviation measurements using the `grep` command to get column indexes for variable name that contains 'mean()' or 'std()'
* Uses descriptive activity names to name the activities in the data set replacing activities ID with activities names.
* Labels data set with descriptive variable names (replacing abbreviations and prefix with full words)
* At the end, creates an independent data set (named `tidy_data.txt`) with average of each variable for each activity and subject

So the script return a new dataset that contains variables calculated based on the mean and standard deviation. 
Each row of the dataset is an average of each activity type for each subject and activity.

You can see the working steps with more detail in the `CodeBook.md` file

## Acknowledge

This project uses the UCI HAR dataset. While using it, I acknowledge the following publication:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones  using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
