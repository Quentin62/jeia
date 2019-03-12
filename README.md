# jeia
Atelier pour la Journée de l'Enseignement de l'Informatique et de l'Algorithmique


## Installation

### R
Installer R en ligne de commande sous linux :
```
sudo apt-get install r-base
```
ou télécharger directement les sources sur le site du [CRAN](https://cran.r-project.org/).

Conseil : utiliser l'IDE [Rstudio](https://www.rstudio.com/products/rstudio/#Desktop) et ouvrir le projet Rstudio [jeia.Rproj](jeia.Rproj).


### Packages R

Dans la console R :
```
install.packages(c("shinydashboard", "shinyjs", "DT", "plotly", "Rmixmod", "FactoMineR"), repos = "https://cran.rstudio.com/")
```

## Lancer l'application

Depuis RStudio, en ouvrant le fichier [ui.R](ui.R) ou [server.R](server.R) et en cliquant sur le bouton `Run App` en haut à droite du fichier.

Depuis la console R, en étant dans le dossier jeia :
```
runApp()
```

## Déployer l'application

* Sur un serveur avec [Shiny Server](https://www.rstudio.com/products/shiny/shiny-server/)
* Sur un serveur shiny : [Shiny Apps](http://www.shinyapps.io)

## Version en ligne

https://quenting.shinyapps.io/jeia/

## Autres documents

* Exemples d'applications : http://modal-demo.lille.inria.fr:3838/smartDataApp/
* [Slides sur la classification](./doc/classif.pdf)
* [Pile ou face](./doc/doc.pdf)

