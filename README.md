# Acom-Patcher

Ce script Bash permet de simplifier l'exécution de certaines tâches courantes sur un système Acom sous Linux via SSH.

## Fonctionnalités

- **Project Watchdog**: Télécharge un fichier `check_net`, le rend exécutable, teste le script et configure un cron pour la stabilité.
- **Panpan-Cleaner**: Télécharge et exécute le script `panpan-cleaner.sh`.
- **Mise à l'heure de l'appareil**: Exécute la commande `ivs-control date`.
- **Mise à jour de l'acom**: Exécute la commande `ivs-installer installBundles`.
- **Vérification de la taille de la partition de stockage des médias**: Vérifie si l'espace de stockage des médias est suffisant.
- **Reconfiguration de la timeZone**: Exécute la commande `sudo dpkg-reconfigure tzdata`.
- **Fonctions Ecran**: Permet d'éteindre ou d'allumer l'écran, d'afficher des informations détaillées sur l'état de l'écran.

## Utilisation

1. Clonez ce dépôt sur votre système Acom.
2. Exécutez le script `acom_patcher.sh`.
3. Choisissez l'option correspondant à la tâche que vous souhaitez effectuer dans le menu.

## Remarque

Assurez-vous d'avoir les autorisations nécessaires pour exécuter les commandes avec `sudo`.
