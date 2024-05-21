#!/bin/bash

# Numéro de version
version="2.2"

# Chemin complet vers tvservice
tvservice_path="/opt/vc/bin/tvservice"

# Fonction pour afficher le titre stylisé
show_title() {
    clear
    echo -e "\e[38;5;208m*********************************************\e[0m"
    echo -e "\e[38;5;208m*           Acom-Patcher (Version $version)           *\e[0m"
    echo -e "\e[38;5;208m*********************************************\e[0m"
    echo
}

# Fonction pour afficher le menu
show_menu() {
    echo -e "\e[38;5;220m------ Menu ------\e[0m"
    echo
    echo -e "\e[38;5;118m1. Project Watchdog\e[0m"
    echo -e "\e[38;5;118m2. Panpan-Cleaner\e[0m"
    echo -e "\e[38;5;118m3. Mise à l'heure de l'appareil\e[0m"
    echo -e "\e[38;5;118m4. Mise à jour de l'acom\e[0m"
    echo -e "\e[38;5;118m5. Vérifier la taille de la partition de stockage des médias\e[0m"
    echo -e "\e[38;5;118m6. Reconfigurer la timeZone\e[0m"
    echo -e "\e[38;5;118m7. Fonctions Ecran\e[0m"
    echo -e "\e[38;5;196m8. Quitter\e[0m"
    echo
}

# Sous-menu pour les fonctions de l'écran
screen_menu() {
    echo -e "\e[38;5;220m-=- Fonctions Ecran -=-\e[0m"
    echo
    echo -e "\e[38;5;118m1. Éteindre l'écran\e[0m"
    echo -e "\e[38;5;118m2. Allumer l'écran\e[0m"
    echo -e "\e[38;5;118m3. Informations détaillées sur l'état de l'écran\e[0m"
    echo -e "\e[38;5;196m4. Retour au menu précédent\e[0m"
    echo
}

# Fonction pour exécuter les commandes
execute_command() {
    case $1 in
        1) echo "ACOM - Project Watchdog V2.01"
           echo "Téléchargement du fichier check_net..."
           wget -O check_net https://package.ivsweb.com/lien.sh
           echo "Rendre le script exécutable..."
           chmod +x check_net
           echo "Test du script..."
           ./check_net # Note: Ne pas lancer en sudo évite le reboot en cas de ping NOK
           echo "Configuration du cron pour la stabilité..."
           echo "@reboot root /path/to/check_net" | sudo tee /etc/cron.d/stability > /dev/null
           echo "Configuration terminée. Il est recommandé de redémarrer l'ACOM pour activer le script."
           ;;
        2) echo "Téléchargement de Panpan-Cleaner..."
           wget "https://sharing.activisu.com/storage/panpan-cleaner.sh" && chmod +x ./panpan-cleaner.sh && sudo ./panpan-cleaner.sh
           ;;
        3) echo "Mise à l'heure de l'appareil..."
           ivs-control date
           ;;
        4) echo "Mise à jour de l'acom..."
           ivs-installer installBundles
           ;;
        5) echo "Vérification de la taille de la partition de stockage des médias..."
           check_media_partition
           ;;
        6) echo "Reconfiguration de la timeZone..."
           reconfigure_timezone
           ;;
        7) screen_functions ;;
        8) echo "Au revoir!"
           exit 0
           ;;
        *) echo "Option invalide. Veuillez sélectionner une option valide."
           ;;
    esac
}

# Fonction pour afficher les informations détaillées sur l'état de l'écran
show_screen_details() {
    echo "Informations détaillées sur l'état de l'écran :"
    echo
    # Récupérer l'état de l'écran
    screen_state=$($tvservice_path -s)
    echo "État de l'écran : $screen_state"
    echo
    # Récupérer la résolution actuelle de l'écran
    screen_resolution=$($tvservice_path -s | grep -oP '(?<=[0-9]x)[0-9]+')
    echo "Résolution actuelle de l'écran : $screen_resolution"
    echo
    # Ajouter d'autres informations si nécessaire
}

# Sous-menu pour les fonctions de l'écran
screen_functions() {
    while true; do
        show_title
        screen_menu
        echo -n "Choisissez une option : "
        read option
        case $option in
            1) echo "Extinction de l'écran..."
               $tvservice_path -o
               ;;
            2) echo "Allumage de l'écran..."
               $tvservice_path -p
               ;;
            3) show_screen_details ;;
            4) break ;;
            *) echo "Option invalide. Veuillez sélectionner une option valide." ;;
        esac
        echo -e "\nAppuyez sur Enter pour continuer..."
        read
    done
}

# Fonction pour vérifier la taille de la partition de stockage des médias
check_media_partition() {
    echo "Vérification de la taille de la partition de stockage des médias..."
    echo
    if df -H | grep -q '/var/cache/activscreen'; then
        partition_used=$(df -H | grep '/var/cache/activscreen' | awk '{print $3}')
        if [ "$partition_used" == "" ]; then
            echo -e "\e[38;5;196mCarte SD corrompue ou mal flashée, merci de déclencher une intervention.\e[0m"
        else
            # Taille maximale autorisée (3Go)
            max_size=3000000
            # Extraire uniquement la valeur numérique
            partition_used=$(echo "$partition_used" | sed 's/[^0-9]//g')
            if [ "$partition_used" -lt "$max_size" ]; then
                echo -e "\e[38;5;196mL'espace de stockage des médias est insuffisant. Veuillez nettoyer les médias.\e[0m"
            else
                echo "L'espace de stockage des médias est suffisant."
            fi
        fi
    else
        echo -e "\e[38;5;196mLa partition de stockage des médias est introuvable.\e[0m"
    fi
}

# Fonction pour reconfigurer la timeZone
reconfigure_timezone() {
    echo "Reconfiguration de la timeZone..."
    echo
    sudo dpkg-reconfigure tzdata
    echo
    echo "La timeZone a été reconfigurée avec succès."
}

# Boucle pour afficher le menu et récupérer l'entrée de l'utilisateur
while true; do
    show_title
    show_menu
    echo -n "Choisissez une option : "
    read option
    execute_command $option
    echo
    echo -e "\nAppuyez sur Enter pour continuer..."
    read
done
