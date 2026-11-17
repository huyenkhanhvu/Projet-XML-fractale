# Génération de fractales avec XML, XSLT et SVG

Projet universitaire consacré à la description et à la génération de figures fractales à partir de données structurées en XML.

L'objectif est de séparer la définition des formes et des transformations de leur rendu graphique : les systèmes fractals sont décrits dans un document XML, structurés par un schéma XSD, puis transformés en images vectorielles SVG grâce à une feuille XSLT 2.0. Un script Python automatise l'exécution des différents cas.

## Fonctionnalités

- Définition de figures géométriques et de systèmes fractals dans un fichier XML.
- Description de transformations géométriques : translation, rotation et mise à l'échelle.
- Application itérative de transformations pour construire des motifs fractals.
- Génération de fichiers SVG à partir du XML via XSLT 2.0 / Saxon-HE.
- Automatisation de neuf générations de fractales avec Python.
- Définition des contraintes de structure et de références dans un schéma XSD.

## Technologies

| Technologie | Rôle |
| --- | --- |
| XML | Description des formes, transformations et systèmes fractals |
| XSD | Définition et contrôle de la structure attendue du XML |
| XSLT 2.0 | Transformation des définitions XML en SVG |
| SVG | Rendu vectoriel des fractales |
| Python 3 | Automatisation des générations |
| Java / Saxon-HE 10.3 | Exécution des transformations XSLT |

## Structure du dépôt

```text
Projet-XML-fractale/
├── README.md               # Documentation du projet
├── fractale.xml            # Formes, transformations et systèmes fractals
├── schema.xsd              # Schéma de description XML
├── rendu.xsl               # Génération SVG via XSLT 2.0
├── main.py                 # Script de génération automatique
├── saxon-he-10.3.jar       # Processeur XSLT Saxon-HE
├── paths.csv               # Données complémentaires de chemins
└── ifs.pdf                 # Document PDF fourni avec le projet
```

## Prérequis

- Python 3.x ;
- Java (JRE ou JDK), accessible depuis le terminal ;
- le fichier `saxon-he-10.3.jar` présent à la racine du projet (déjà inclus dans le dépôt).

Vérifier les installations :

```
python3 --version
java -version
```

Le script utilise uniquement des modules de la bibliothèque standard Python (`os` et `subprocess`).

## Installation et exécution

Cloner le dépôt :

```
git clone https://github.com/huyenkhanhvu/Projet-XML-fractale.git
cd Projet-XML-fractale
```

Générer les fractales :

```
python3 main.py
```

Le script appelle Saxon-HE pour chaque système déclaré dans `tests_a_generer` et écrit les fichiers SVG dans le dossier courant.

### Fractales générées

| Système XML | Fichier SVG généré |
| --- | --- |
| `sys_sierpinski` | `01_sierpinski_triangle.svg` |
| `sys_tapis` | `02_sierpinski_tapis.svg` |
| `sys_penta` | `03_sierpinski_pentagone.svg` |
| `sys_spirale_tri` | `04_spirale_triangle.svg` |
| `sys_spirale_carre` | `05_spirale_carre.svg` |
| `sys_spirale_penta` | `06_spirale_pentagone.svg` |
| `sys_penta_compose` | `07_compose_penta_spirale.svg` |
| `sys_flocon` | `8_sys_flocon.svg` |
| `sys_pi` | `9_fractale_pi.svg` |

Les noms ci-dessus correspondent exactement à la configuration actuelle de `main.py`.

Ouvrir un fichier `.svg` généré dans un navigateur ou dans une application compatible SVG pour visualiser le résultat.

### Générer une seule fractale

Il est aussi possible d'appeler directement Saxon-HE. Par exemple, pour le triangle de Sierpinski :

```
java -jar saxon-he-10.3.jar \
  -s:fractale.xml \
  -xsl:rendu.xsl \
  -o:triangle.svg \
  sys_id=sys_sierpinski
```

Le paramètre `sys_id` désigne l'identifiant du système fractal à rendre, tel qu'il est défini dans `fractale.xml`.

## Principe de fonctionnement

1. Modélisation (`fractale.xml`) : les formes de base, les ensembles de transformations et les systèmes fractals sont déclarés en XML.
2. Structuration (`schema.xsd`) : le schéma décrit les éléments attendus et impose notamment des contraintes sur les identifiants et leurs références.
3. Transformation (`rendu.xsl`) : les éléments XML sont interprétés afin de construire une image SVG par application de transformations et d'étapes itératives.
4. Automatisation (`main.py`) : Python exécute Saxon-HE pour chaque système et génère les fichiers SVG correspondants.

Un système fractal associe une forme de base à une ou plusieurs étapes de transformation, chacune avec un nombre d'itérations (`iter`).

## Personnalisation

Pour explorer ou modifier un système fractal :

1. Ouvrir `fractale.xml`.
2. Modifier une forme ou un ensemble de transformations existant, ou définir un nouveau système avec son identifiant.
3. Ajuster les étapes et leur nombre d'itérations.
4. Pour la génération automatique, ajouter l'identifiant et un nom de fichier dans le dictionnaire `tests_a_generer` de `main.py`.
5. Relancer `python3 main.py` et ouvrir le SVG obtenu.

Veiller à respecter la structure attendue dans `schema.xsd`. Le script `main.py` ne lance pas explicitement une validation XSD avant la génération.

## Points techniques abordés

- Structuration de données avec XML et XSD.
- Transformations déclaratives avec XSLT 2.0.
- Génération de graphiques vectoriels avec SVG.
- Modélisation de transformations géométriques et de processus itératifs.
- Orchestration d'un outil Java depuis Python.

## Références du projet

- [Dépôt GitHub](https://github.com/huyenkhanhvu/Projet-XML-fractale)
- Documentation du processeur [Saxon](https://www.saxonica.com/documentation12/)
- Documentation [SVG — MDN](https://developer.mozilla.org/fr/docs/Web/SVG)
