PACKAGE = *.dtx \
		  *.ins \
		  reledmac.pdf \
		  reledpar.pdf \
			migration.pdf \
		  README \
		  Makefile \
		  latexmkrc \



.PHONY: all dist clean


all: reledmac.sty reledmac.pdf  reledpar.sty reledpar.pdf migration.pdf dist

doc: *.pdf

migration.pdf: migration.dtx
	xelatex $<
	xelatex $<
	xelatex $<

README: README.md
	pandoc README.md -o README

%.sty: %.ins %.dtx
	rm -f $*.sty $*tex
	@pdflatex $*.ins

%.pdf: %.sty %.dtx
	@xelatex $*.dtx
	@makeindex -s gind.ist -o $*.ind $*.idx
	@makeindex -s gglo.ist -o $*.gls $*.glo
	@xelatex $*.dtx
	@makeindex -s gind.ist -o $*.ind $*.idx
	@makeindex -s gglo.ist -o $*.gls $*.glo
	@xelatex $*.dtx


dist: $(PACKAGE) examples
	rm -rf reledmac
	mkdir reledmac
	$(MAKE) -C examples all
	mkdir reledmac/examples
	ln examples/*pdf reledmac/examples
	ln examples/*tex reledmac/examples
	ln examples/*xdy reledmac/examples
	ln examples/makefile reledmac/examples
	mkdir reledmac/doc-include
	ln doc-include/*dtx reledmac/doc-include
	ln $(PACKAGE) reledmac
	@$(RM) ../reledmac.zip
	zip -r ../reledmac.zip reledmac


clean:
	$(MAKE) -C examples clean
	@$(RM) *.aux *.log *.out *.toc *tex *.pdf reledmac.sty reledpar.sty  *ind *ilg  *lof *idx *glo *gls ../reledmac.zip
