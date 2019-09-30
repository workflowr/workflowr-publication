
NAME := workflowr-publication
BIB := references

all: $(NAME).pdf main.tex

%.pdf %.aux %-supplement.aux: %.tex $(BIB).bib
	python format-bibtex.py $(BIB).bib
	pdflatex -shell-escape $(NAME)
	bibtex $(NAME)
	pdflatex -shell-escape $(NAME)
	pdflatex -shell-escape $(NAME)

main.tex: $(NAME).tex
	cp $< $@

$(NAME).tex: $(NAME).docx format.R
	pandoc -t plain -o $@ $<
	Rscript format.R $@

clean:
	rm -f $(NAME)*.aux $(NAME).bbl $(NAME).blg $(NAME).dvi \
              $(NAME).log $(NAME).out $(NAME).pdf \
              *cpt figures/*converted-to.pdf

view: $(NAME).pdf
	evince $< &
