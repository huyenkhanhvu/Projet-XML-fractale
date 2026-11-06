import subprocess
import os

# Configuration des fichiers
SAXON_JAR = "saxon-he-10.3.jar"
XML_FILE = "fractale.xml"
XSL_FILE = "rendu.xsl"

# Dictionnaire contenant tous les tests à générer
tests_a_generer = {
    "sys_sierpinski": "01_sierpinski_triangle.svg",
    "sys_tapis": "02_sierpinski_tapis.svg",
    "sys_penta": "03_sierpinski_pentagone.svg",
    "sys_spirale_tri": "04_spirale_triangle.svg",
    "sys_spirale_carre": "05_spirale_carre.svg",
    "sys_spirale_penta": "06_spirale_pentagone.svg",
    "sys_penta_compose": "07_compose_penta_spirale.svg",
    "sys_flocon": "8_sys_flocon.svg",
    "sys_pi": "9_fractale_pi.svg"
}

# Fonction principale qui genere les fichiers svg
def generer_svg(sys_id, fichier_sortie):

    print(f"Génération de {fichier_sortie}")
    
    # Construction de la commande de base
    commande = [
        "java",
        "-jar", SAXON_JAR,
        f"-s:{XML_FILE}",
        f"-xsl:{XSL_FILE}",
        f"-o:{fichier_sortie}",
        f"sys_id={sys_id}"
    ]
    
    try:
        
        # Exécution de la commande dans le terminal
        result = subprocess.run(commande, capture_output=True, text=True, check=True)
        print(f"   {fichier_sortie} a été créé.\n")

    except subprocess.CalledProcessError as e:
        print(f"  -> ERREUR lors de la génération de {fichier_sortie}.")

    except FileNotFoundError:
        print("  -> ERREUR commande java pas trouvé.")
        exit(1)



def main():
    
    # Vérification de la présence du fichier Saxon
    if not os.path.exists(SAXON_JAR):
        print(f"ERREUR fichier {SAXON_JAR} introuvable ")
        return

    # Lancement de tous les tests
    for sys_id, fichier_sortie in tests_a_generer.items():
        generer_svg(sys_id, fichier_sortie)
        
    print("Génération terminée ")

if __name__ == "__main__":
    main()