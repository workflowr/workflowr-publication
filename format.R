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

# Format function names (brute force b/c getting clever with regex was hard to
# maintain), e.g. wflow_start() -> \texttt{wflow\_start()}
lines_out <- str_replace_all(lines_out,
                             "wflow_start\\(\\)",
                             "\\\\texttt{wflow\\\\_start()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_build\\(\\)",
                             "\\\\texttt{wflow\\\\_build()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_publish\\(\\)",
                             "\\\\texttt{wflow\\\\_publish()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_status\\(\\)",
                             "\\\\texttt{wflow\\\\_status()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_git_push\\(\\)",
                             "\\\\texttt{wflow\\\\_git\\\\_push()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_use_github\\(\\)",
                             "\\\\texttt{wflow\\\\_use\\\\_github()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_use_gitlab\\(\\)",
                             "\\\\texttt{wflow\\\\_use\\\\_gitlab()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_site\\(\\)",
                             "\\\\texttt{wflow\\\\_site()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_git_pull\\(\\)",
                             "\\\\texttt{wflow\\\\_git\\\\_pull()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_html\\(\\)",
                             "\\\\texttt{wflow\\\\_html()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_git_remote\\(\\)",
                             "\\\\texttt{wflow\\\\_git\\\\_remote()}")
lines_out <- str_replace_all(lines_out,
                             "wflow_git_config\\(\\)",
                             "\\\\texttt{wflow\\\\_git\\\\_config()}")
lines_out <- str_replace_all(lines_out,
                             "render\\(\\)",
                             "\\\\texttt{render()}")
lines_out <- str_replace_all(lines_out,
                             "render_site\\(\\)",
                             "\\\\texttt{render\\\\_site()}")
lines_out <- str_replace_all(lines_out,
                             "html_document\\(\\)",
                             "\\\\texttt{html\\\\_document()}")
lines_out <- str_replace_all(lines_out,
                             "sessionInfo\\(\\)",
                             "\\\\texttt{sessionInfo()}")
lines_out <- str_replace_all(lines_out,
                             "set.seed\\(\\)",
                             "\\\\texttt{set.seed()}")

# Replace # with \# for LaTeX
lines_out <- str_replace_all(lines_out, "#", "\\\\#")

# Replace & with \& for LaTeX
lines_out <- str_replace_all(lines_out, "&", "\\\\&")

# Remove empty [] where figures were in Word document
lines_out <- str_replace_all(lines_out, "^\\[\\]$", "")

# Fix \texttt{\_workflowr.yml} split over 2 lines
lines_out <- str_replace(lines_out, "\\\\texttt\\{\\\\$", "")
lines_out <- str_replace(lines_out, "^_workflowr.yml", "\\\\texttt\\{\\\\_workflowr.yml")

# Reference figures by labels
lines_out <- str_replace_all(lines_out, "FIGURE 1", "Figure \\\\ref\\{fig:organized}\\")
lines_out <- str_replace_all(lines_out, "FIGURE 2", "Figure \\\\ref\\{fig:publish}\\")
lines_out <- str_replace_all(lines_out, "FIGURE 3", "Figure \\\\ref\\{fig:versioned}\\")
lines_out <- str_replace_all(lines_out, "FIGURE 4", "Figure \\\\ref\\{fig:reproducible}\\")

# Bold names of software
software <- c(
  "adapr",
  "archivist",
  "blogdown",
  "bookdown",
  "cacher",
  "callr",
  "checkpoint",
  "conda",
  "devtools",
  "Docker",
  "drake",
  "Git LFS", # Needs to come before Git
  "Git",
  "git2r",
  "GNU Make",
  "Homebrew",
  "knitr",
  "Kubernetes",
  "libgit2",
  "msigdbr",
  "packrat",
  "pandoc",
  "pkgdown",
  "ProjectTemplate",
  "rmarkdown",
  "rprojroot",
  "rrtools",
  "RStudio",
  "RSuite",
  "Seurat",
  "Singularity",
  "Snakemake",
  "Sumatra",
  "switchr",
  "usethis",
  "workflowr",
  "Workflowr"
)
#browser()
#lines_out <- str_replace_all(lines_out, " workflowr", " \\\\textbf\\{workflowr}")

for (s in software) {
 lines_out <- str_replace_all(lines_out,
                              sprintf("[:space:](%s)\\b", s),
                              " \\\\textbf\\{\\1}")
 # Handle the edge case where the package is the start of a new line
 lines_out <- str_replace_all(lines_out,
                              sprintf("^(%s)\\b", s),
                              " \\\\textbf\\{\\1}")
 # Handle the edge case where software is in parentheses
 lines_out <- str_replace_all(lines_out,
                              sprintf("\\((%s)\\b", s),
                              " \\(\\\\textbf\\{\\1}")
}

writeLines(lines_out, con = fname)
