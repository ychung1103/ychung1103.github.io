Answers:	Answers.ps

clean:		Answers.dvi Answers.ps
		/bin/rm Answers.dvi Answers.ps

Answers.ps:	Answers.dvi
		/usr/local/apps/bin/dvips -o Answers.ps Answers.dvi

Answers.dvi:	Answers.tex
		/usr/local/apps/bin/latex Answers.tex ;
		/usr/local/apps/bin/latex Answers.tex

