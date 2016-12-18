# Don't include *.md or *.txt here, since converting those is less common.
SOURCES=$(wildcard *.tex *.svg)
TARGETS=$(patsubst %.svg,%.pdf,$(patsubst %.tex,%.pdf,$(SOURCES))) notes.pdf map-7.pdf
STATES=ma md nc2011 nc2016 fl az
STATE_MAPS=$(patsubst %,%.pdf,$(STATES))

PANDOC=pandoc -V geometry:margin=1in

all: $(TARGETS)

view: all
	ls *.pdf | grep 'map-[0-9].pdf' | xargs evince

map-0.pdf: map-0.tex map-0.png
	pdflatex map-0.tex

map-7.pdf: $(STATE_MAPS)
	pdftk $(STATE_MAPS) cat output map-7.pdf

ma.pdf:
	wget https://www.sec.state.ma.us/cis/cispdf/MA-Congressional-Map-2015.pdf -O ma.pdf
	touch ma.pdf

md.pdf:
	wget https://planning.maryland.gov/PDF/Redistricting/2010maps/Cong/Statewide.pdf -O md.pdf
	touch md.pdf

nc2011.pdf:
	wget http://www.ncleg.net/GIS/Download/District_Plans/DB_2011/Congress/Rucho-Lewis_Congress_3/Maps/mapSimple.pdf -Onc2011.pdf
	touch nc2011.pdf

nc2016.pdf:
	wget http://www.ncleg.net/GIS/Download/District_Plans/DB_2016/Congress/2016_Contingent_Congressional_Plan_-_Corrected/Maps/mapSimple.pdf -O nc2016.pdf
	touch nc2016.pdf

fl.pdf:
	wget https://www.flsenate.gov/usercontent/session/redistricting/map_and_stats_11x17v5b_sc14-1905.pdf -O fl-full.pdf
	pdftk fl-full.pdf cat 1 output fl.pdf

az.pdf:
	wget http://azredistricting.org/Maps/Final-Maps/Congressional/Maps/Final%20Congressional%20Districts%20-%20Statewide%208x11.pdf -O az.pdf
	touch az.pdf

%.pdf: %.svg
	inkscape --export-pdf $(<:.svg=.pdf) $<

%.pdf: %.md
	$(PANDOC) -o $(<:.md=.pdf) $<
