all: t5

t5: ngspice5.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	ps2pdf voutdb.ps voutdb.pdf
	ps2pdf voutph.ps voutph.pdf
	ps2pdf vamp_out.ps vamp_out.pdf
	ps2pdf vnon_inv.ps vnon_inv.pdf
	
	
ngspice5.log: ../sim/t5.net
	ngspice -b $< -o $@

clean:
	@rm -f *.log *.txt *.pdf *.tex *.ps *~

.PHONY: all clean
