# À faire


- Supprimer le slot `number-atoms` de la classe `system` :
  ; il sera calculé dynamiquement à partir des résidus

- Ajouter une fonction/méthode :
  (defmethod system-number-atoms ((s system))
    (reduce #'+ (mapcar #'length (mapcar #'residue-atoms (system-residues s)))))

- Ajouter une fonction utilitaire :
  (defun flatten-residues (residues)
    ;; Retourne une liste de (res-id res-name atom)
    (loop for residue in residues
          for res-id from 1
          append (loop for atom in (residue-atoms residue)
                       collect (list res-id (residue-name residue) atom))))

- Ajouter une fonction :
  (defun gro-line (atom res-id res-name atom-id)
    ;; Génère une ligne formatée pour un atome dans un .gro
    (vdestructuring-bind (x y z) (single-atom-position atom)
      (format nil "~5d%-5a~5a~5d~8,3f~8,3f~8,3f"
              res-id res-name (string-upcase (symbol-name (single-atom-name atom))) atom-id
              x y z)))

- Mettre à jour `write-gro` pour écrire les atomes :
  - Utiliser `flatten-residues`
  - Boucler avec `atom-id from 1` et écrire chaque ligne avec `gro-line`


## VMD

VMD supporte du scripting via [TCL](https://www.ks.uiuc.edu/Training/Tutorials/vmd/tutorial-html/node4.html). On peut donc ouvrir une socket et pouvoir interagir avec lui depuis le REPL.

Notamment, définir un système, ajouter des atomes, et le charger directement dans VMD pour le visualiser.

Il faut que je regarde du côté d'[usocket](https://lispcookbook.github.io/cl-cookbook/sockets.html)


## Test unitaires

Ca serait intéressant de pouvoir mettre en place des tests unitaires (potentiellement avec fiveam), au moins sur la génération de fichiers (facile de checker).

Pour la communication avec VMD, ça peut être un peu plus compliqué.