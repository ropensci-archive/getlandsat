all: move rmd2md

move:
		cp inst/vign/getlandsat_vignette.md vignettes;\
		cp -r inst/vign/img/ vignettes/img/

rmd2md:
		cd vignettes;\
		mv getlandsat_vignette.md getlandsat_vignette.Rmd
