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

writeLines(lines_out, con = fname)
