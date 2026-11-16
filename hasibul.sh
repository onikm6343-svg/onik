#!/data/data/com.termux/files/usr/bin/bash

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- File Selector Function ---
select_file_popup() {
    local target_file="$1"
    echo -e "${YELLOW}Enter full path of the .img file (e.g. /sdcard/Download/boot.img):${NC}"
    read -e -p "File Path: " filepath
    if [ -f "$filepath" ]; then
        cp "$filepath" "$target_file"
        return 0
    else
        echo -e "${RED}[!] File not found! Please check the path.${NC}"
        return 1
    fi
}
# --- ADB Menu ---
menu_2() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}-------------- ${GREEN}ADB Menu ${CYAN}----------------${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "[${YELLOW}1${NC}] ${YELLOW}Check ADB Devices${NC}"
    echo -e "[${YELLOW}2${NC}] ${YELLOW}Reboot to System${NC}"
    echo -e "[${YELLOW}3${NC}] ${YELLOW}Reboot to Recovery${NC}"
    echo -e "[${YELLOW}4${NC}] ${YELLOW}Reboot to Bootloader (Fastboot)${NC}"
    echo -e "[${YELLOW}5${NC}] ${YELLOW}Reboot to FastbootD${NC}"
    echo ""
    echo -e "[${RED}88${NC}] ${RED}Back${NC}   [${CYAN}99${NC}] ${CYAN}Home${NC}   [${RED}00${NC}] ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice

    case $choice in
        1)
            clear
            termux-adb devices
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        2)
            clear
            termux-adb reboot
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        3)
            clear
            termux-adb reboot recovery
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        4)
            clear
            termux-adb reboot bootloader
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        5)
            clear
            termux-adb reboot fastboot
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        88) return ;;
        99) main_menu ;;
        00) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}
# --- Fastboot Menu ---
menu_3() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}------------ ${GREEN}Fastboot Menu ${CYAN}-------------${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "[${YELLOW}1${NC}] ${YELLOW}Check Fastboot Devices${NC}"
    echo -e "${CYAN}--------- ${BLUE}--- Reboot Menu ---${NC} ${CYAN}----------${NC}"
    echo -e "[${YELLOW}2${NC}] ${YELLOW}Reboot to System${NC}"
    echo -e "[${YELLOW}3${NC}] ${YELLOW}Reboot to Recovery${NC}"
    echo -e "[${YELLOW}4${NC}] ${YELLOW}Reboot to FastbootD${NC}"
    echo -e "[${YELLOW}5${NC}] ${YELLOW}Reboot to Bootloader${NC}"
    echo -e "${CYAN}----- ${BLUE}--- Device Informations ---${NC} ${CYAN}------${NC}"
    echo -e "[${YELLOW}6${NC}] ${YELLOW}Get Product Name${NC}"
    echo -e "[${YELLOW}7${NC}] ${YELLOW}Check Bootloader Unlock Status${NC}"
    echo -e "[${YELLOW}8${NC}] ${YELLOW}Get All Variables${NC}"
    echo -e "${CYAN}------ ${BLUE}--- Bootloader Unlock ---${NC} ${CYAN}-------${NC}"
    echo -e "[${YELLOW}9${NC}] ${YELLOW}Unlock Bootloader (All Device)${NC}"
    echo -e "${CYAN}---------- ${BLUE}--- Flash Menu ---${NC} ${CYAN}----------${NC}"
    echo -e "[${YELLOW}10${NC}] ${YELLOW}Flash boot${NC}"
    echo -e "[${YELLOW}11${NC}] ${YELLOW}Flash init_boot${NC}"

    echo ""
    echo -e "[${RED}88${NC}] ${RED}Back${NC}   [${CYAN}99${NC}] ${CYAN}Home${NC}   [${RED}00${NC}] ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice

    case $choice in
        1)
            clear
            timeout 10 termux-fastboot devices
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        2)
            clear
            termux-fastboot reboot
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        3)
            clear
            termux-fastboot reboot recovery
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        4)
            clear
            yes "Y" | termux-fastboot reboot fastboot
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        5)
            clear
            termux-fastboot reboot bootloader
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        6)
            clear
            termux-fastboot getvar product
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        7)
            clear
            termux-fastboot oem device-info 2>&1 || termux-fastboot getvar unlocked
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;

        8)
            clear
            termux-fastboot getvar all
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        9)
            clear
            termux-fastboot flashing unlock
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        10)
            clear
            if select_file_popup "hasibul_temp_$$.img"; then echo -e "\n${CYAN}[*] Executing command...${NC}"; timeout 15 termux-fastboot flash boot hasibul_temp_$$.img; rm -f "hasibul_temp_$$.img"; fi
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        11)
            clear
            if select_file_popup "hasibul_temp_$$.img"; then echo -e "\n${CYAN}[*] Executing command...${NC}"; timeout 15 termux-fastboot flash init_boot hasibul_temp_$$.img; rm -f "hasibul_temp_$$.img"; fi
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        88) return ;;
        99) main_menu ;;
        00) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}

# --- Main Menu ---
main_menu() {
  while true; do
    clear
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}------------- ${GREEN}DEV HASIBUL ${CYAN}--------------${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "[${YELLOW}1${NC}] ${YELLOW}Master Setup${NC}"
    echo -e "[${YELLOW}2${NC}] ${CYAN}ADB Menu${NC}"
    echo -e "[${YELLOW}3${NC}] ${CYAN}Fastboot Menu${NC}"

    echo ""
    echo -e "[${RED}88${NC}] ${RED}Back${NC}   [${CYAN}99${NC}] ${CYAN}Home${NC}   [${RED}00${NC}] ${RED}Exit${NC}"
    echo -e "${CYAN}========================================${NC}"
    read -p "Choose an option: " choice

    case $choice in
        1)
            clear
            DEBIAN_FRONTEND=noninteractive yes "Y" | pkg update -y && pkg upgrade -y -o Dpkg::Options::="--force-confnew"
            yes "Y" | curl -s https://githubusercontent.com | bash
            yes "Y" | termux-setup-storage
            echo -e "\n${CYAN}----------------------------------------${NC}"
            read -p "Press Enter to return to menu..." ;;
        2)
            menu_2 ;;
        3)
            menu_3 ;;
        88) echo -e "\n${YELLOW}Already in Home Menu!${NC}"; sleep 1 ;;
        99) continue ;;
        00) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
  done
}

# --- Start Script ---
main_menu


