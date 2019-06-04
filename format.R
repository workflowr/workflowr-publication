#!/usr/bin/env Rscript

if (!requireNamespace("stringr", quietly = TRUE))
  stop("Please install the package stringr and re-run")

library(stringr)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 1) {
  stop("Usage: Rscript format.R filename")
} else if (length(args) == 1) {
  fname <- args
} else {
  fname <- "workflowr-publication.tex"
}

lines_in <- readLines(fname)
lines_out <- lines_in

# wflow_start -> \verb|wflow_start()|
lines_out <- str_replace_all(lines_out, "([a-z,_]+\\(\\))", "\\\\verb|\\1|")

# Fix devtools::session_info()
lines_out <- str_replace_all(lines_out,
                             "\\\\verb\\|session_info\\(\\)\\|",
                             "session_info\\(\\)")

# Replace # with \# for LaTeX
lines_out <- str_replace_all(lines_out, "#", "\\\\#")

# Remove empty [] where figures were in Word document
lines_out <- str_replace_all(lines_out, "^\\[\\]$", "")

# Reference figures by labels
lines_out <- str_replace_all(lines_out, "FIGURE 1", "Figure \\\\ref\\{fig:organized}\\")
lines_out <- str_replace_all(lines_out, "FIGURE 2", "Figure \\\\ref\\{fig:publish}\\")
lines_out <- str_replace_all(lines_out, "FIGURE 3", "Figure \\\\ref\\{fig:versioned}\\")
lines_out <- str_replace_all(lines_out, "FIGURE 4", "Figure \\\\ref\\{fig:reproducible}\\")

writeLines(lines_out, con = fname)
