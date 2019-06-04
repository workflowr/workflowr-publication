
NAME := workflowr-publication
BIB := references

all: $(NAME).pdf

%.pdf %.aux %-supplement.aux: %.tex $(BIB).bib
	python format-bibtex.py $(BIB).bib
	pdflatex -shell-escape $(NAME)
	bibtex $(NAME)
	pdflatex -shell-escape $(NAME)
	pdflatex -shell-escape $(NAME)

$(NAME).tex: $(NAME).docx
	pandoc -t plain -o $@ $<
	Rscript format.R $@

clean:
	rm -f $(NAME)*.aux $(NAME).bbl $(NAME).blg $(NAME).dvi \
              $(NAME).log $(NAME).out $(NAME).pdf \
              *cpt figures/*converted-to.pdf
