# ------------------------------------------------------------
# type "make" command in the Linux terminal create report.pdf
#
# type "make clean" to delete all generated files
# ------------------------------------------------------------



all:	python
	make -C mat
	make -C sim
	make -C doc
	cp doc/report.pdf .

python:
	@echo "Please enter the lowest student number in your group:"
	@python t2_datagen.py > ../t2/mat/data.txt
	
clean:
	make -C mat clean
	make -C sim clean
	make -C doc clean

.PHONY: all clean


