# À faire

## VMD

VMD supporte du scripting via [TCL](https://www.ks.uiuc.edu/Training/Tutorials/vmd/tutorial-html/node4.html). On peut donc ouvrir une socket et pouvoir interagir avec lui depuis le REPL.

Notamment, définir un système, ajouter des atomes, et le charger directement dans VMD pour le visualiser.

Il faut que je regarde du côté d'[usocket](https://lispcookbook.github.io/cl-cookbook/sockets.html)


## Test unitaires

Ca serait intéressant de pouvoir mettre en place des tests unitaires (potentiellement avec fiveam), au moins sur la génération de fichiers (facile de checker).

Pour la communication avec VMD, ça peut être un peu plus compliqué.