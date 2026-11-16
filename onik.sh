#!/data/data/com.termux/files/usr/bin/bash

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[1;37m'
P='\033[1;35m'
N='\033[0m'

run_otg() {
    local CMD="$*"
    if su -c "id" >/dev/null 2>&1; then
        su -c "$CMD"
    else
        USB_DEV=$(termux-usb -l 2>/dev/null | grep -o '/dev/bus/usb/[0-9]*/[0-9]*' | head -n 1)
        if [ -n "$USB_DEV" ]; then
            echo -e "${C}[*] OTG Device Found: $USB_DEV${N}"
            echo -e "${Y}[!] Tap 'OK' on USB Permission popup if asked...${N}"
            termux-usb -r "$USB_DEV" >/dev/null 2>&1
            termux-usb -e "$CMD" "$USB_DEV"
        else
            $CMD
        fi
    fi
}

banner() {
    clear
    if su -c "id" >/dev/null 2>&1; then
        R_STAT="${G}ROOTED${N}"
    else
        R_STAT="${Y}NON-ROOT${N}"
    fi
    IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
    [ -z "$IP" ] && IP="${R}Offline${N}" || IP="${G}$IP${N}"

    echo -e "${C}+--------------------------------------+${N}"
    echo -e "${C}|${W}      ONIK PRO MASTER SUITE v3.0      ${C}|${N}"
    echo -e "${C}|${P}         Developer : MD Onik          ${C}|${N}"
    echo -e "${C}+--------------------------------------+${N}"
    echo -e "${C}|${N} Mode: $R_STAT | IP: $IP"
    echo -e "${C}+--------------------------------------+${N}"
    echo ""
}

root_setup_menu() {
    while true; do
        clear
        echo -e "${C}+--------------------------------------+${N}"
        echo -e "${C}|${W}     MASTER SETUP 1 (ROOT METHODS)    ${C}|${N}"
        echo -e "${C}+--------------------------------------+${N}"
        echo -e "  ${G}1)${N} Magisk Root Setup"
        echo -e "  ${G}2)${N} KernelSU (KSU) Setup"
        echo -e "  ${G}3)${N} APatch Root Setup"
        echo -e "  ${G}4)${N} SuperSU / Generic Root Setup"
        echo -e "  ${R}0)${N} Back to Main Menu"
        echo ""
        read -p "Select Root Type [0-4]: " r_ch

        case $r_ch in
            1|2|3|4)
                echo -e "\n${Y}[*] Granting Storage & Root Permissions...${N}"
                termux-setup-storage
                sleep 2
                echo -e "${Y}[*] Installing Root, OTG & Flashing Packages...${N}"
                pkg update -y && pkg upgrade -y
                pkg install -y root-repo tsu python nodejs git wget curl termux-api libusb nmap net-tools iproute2 dnsutils android-tools
                pip install --upgrade pip >/dev/null 2>&1
                pip install speedtest-cli >/dev/null 2>&1
                
                if [ "$r_ch" == "1" ]; then
                    su -c "magisk -v" 2>/dev/null || echo -e "${Y}[!] Tap Grant on Magisk Popup!${N}"
                elif [ "$r_ch" == "2" ]; then
                    su -c "ksud -V" 2>/dev/null || echo -e "${Y}[!] Allow Termux in KernelSU App!${N}"
                elif [ "$r_ch" == "3" ]; then
                    su -c "apd -V" 2>/dev/null || echo -e "${Y}[!] Allow Termux in APatch App!${N}"
                fi
                echo -e "\n${G}[OK] Root Master Setup Completed!${N}"
                read -p "Press Enter..."
                ;;
            0) break ;;
            *) echo -e "${R}[!] Invalid option!${N}"; sleep 1 ;;
        esac
    done
}

nonroot_setup() {
    clear
    echo -e "${Y}[*] Starting Master Setup 2 (Non-Root & OTG ADB)...${N}"
    termux-setup-storage
    sleep 2
    echo -e "${Y}[*] Installing Non-Root + OTG USB Packages...${N}"
    pkg update -y && pkg upgrade -y
    pkg install -y python nodejs curl wget git termux-api libusb nmap net-tools iproute2 dnsutils android-tools
    pip install --upgrade pip >/dev/null 2>&1
    pip install speedtest-cli >/dev/null 2>&1
    echo -e "\n${G}[OK] Non-Root & OTG Setup Completed!${N}"
    read -p "Press Enter..."
}

wifi_tools_menu() {
    while true; do
        clear
        echo -e "${C}+--------------------------------------+${N}"
        echo -e "${C}|${W}        WIFI & NETWORK TOOLKIT        ${C}|${N}"
        echo -e "${C}+--------------------------------------+${N}"
        echo -e "  ${G}1)${N} Scan Nearby WiFi"
        echo -e "  ${G}2)${N} My WiFi & IP Info"
        echo -e "  ${G}3)${N} Connected Devices"
        echo -e "  ${G}4)${N} Internet Speed Test"
        echo -e "  ${G}5)${N} Gaming Ping Test"
        echo -e "  ${G}6)${N} Router / IP Port Scan"
        echo -e "  ${G}7)${N} Website IP / DNS Lookup"
        echo -e "  ${G}8)${N} Saved WiFi Passwords (Root)"
        echo -e "  ${R}0)${N} Back to Main Menu"
        echo ""
        read -p "Choose [0-8]: " w_ch

        case $w_ch in
            1)
                echo -e "\n${Y}[*] Scanning WiFi (Turn ON GPS)...${N}"
                termux-wifi-scaninfo 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(f'{\"WiFi Name\":<20} | {\"Signal\"}')
    print('-'*34)
    for n in sorted(data, key=lambda x: x.get('rssi', -100), reverse=True):
        print(f'{(n.get(\"ssid\") or \"<Hidden>\")[:20]:<20} | {n.get(\"rssi\", \"N/A\")} dBm')
except Exception:
    print('Error! Install Termux:API & turn ON GPS.')
"
                read -p "Press Enter..." ;;
            2)
                GW=$(ip route | grep default | awk '{print $3}')
                PUB=$(curl -s --max-time 4 ifconfig.me)
                LOC=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
                echo -e "\nLocal IP  : ${G}${LOC:-Offline}${N}"
                echo -e "Router IP : ${G}${GW:-N/A}${N}"
                echo -e "Public IP : ${G}${PUB:-Offline}${N}"
                termux-wifi-connectioninfo 2>/dev/null | grep -E "ssid|rssi|link_speed_mbps" | tr -d '",'
                read -p "Press Enter..." ;;
            3)
                IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
                [ -z "$IP" ] && echo -e "${R}Offline!${N}" || nmap -sn $(echo $IP | cut -d"." -f1-3).0/24 | grep -E "Nmap scan|MAC"
                read -p "Press Enter..." ;;
            4)
                speedtest-cli --simple 2>/dev/null || echo -e "${R}Run Master Setup first!${N}"
                read -p "Press Enter..." ;;
            5)
                ping -c 4 1.1.1.1 | tail -n 3
                read -p "Press Enter..." ;;
            6)
                GW=$(ip route | grep default | awk '{print $3}')
                read -p "Target IP [$GW]: " TIP
                [ -z "$TIP" ] && TIP=$GW
                nmap -F $TIP | grep "open"
                read -p "Press Enter..." ;;
            7)
                read -p "Domain (e.g. google.com): " DOM
                [ -n "$DOM" ] && nslookup $DOM | grep -E "Name:|Address:" | tail -n +3
                read -p "Press Enter..." ;;
            8)
                su -c 'grep -E "<string name=\"SSID\">|<string name=\"PreSharedKey\">" /data/misc/apexdata/com.android.wifi/WifiConfigStore.xml 2>/dev/null | sed -e "s/<[^>]*>//g" -e "s/^[ \t]*//" | awk "NR%2{printf \"WiFi: %s -> \", \$0; next;} {print \"Pass: \" \$0}"'
                read -p "Press Enter..." ;;
            0) break ;;
            *) echo -e "${R}[!] Invalid!${N}"; sleep 1 ;;
        esac
    done
}

adb_fastboot_menu() {
    while true; do
        clear
        echo -e "${C}+--------------------------------------+${N}"
        echo -e "${C}|${W}   UNIVERSAL ADB & FASTBOOT FLASHER   ${C}|${N}"
        echo -e "${C}+--------------------------------------+${N}"
        echo -e "${Y} [CONNECTION & INFO]${N}"
        echo -e "  ${G}1)${N} Check ADB Devices"
        echo -e "  ${G}2)${N} Check Fastboot Devices"
        echo -e "  ${G}3)${N} Check Bootloader & Active Slot (A/B)"
        echo -e "${Y} [REBOOT CONTROLS]${N}"
        echo -e "  ${G}4)${N} Normal Reboot (System)"
        echo -e "  ${G}5)${N} Reboot to Bootloader / Fastboot"
        echo -e "  ${G}6)${N} Reboot to FastbootD (Dynamic)"
        echo -e "  ${G}7)${N} Reboot to Recovery Mode"
        echo -e "  ${G}8)${N} Reboot to EDL Mode (Qualcomm)"
        echo -e "${Y} [UNIVERSAL ROOT & FLASHING]${N}"
        echo -e "  ${G}9)${N} Temporary Boot (fastboot boot)"
        echo -e " ${G}10)${N} Flash Boot Image (All Android)"
        echo -e " ${G}11)${N} Flash Init_Boot Image (Newer OS)"
        echo -e " ${G}12)${N} Flash Vendor_Boot Image"
        echo -e " ${G}13)${N} Flash Vbmeta (Disable Verity)"
        echo -e " ${G}14)${N} Flash Custom Recovery (TWRP/OFOX)"
        echo -e " ${G}15)${N} Sideload Zip via ADB (Magisk/ROM)"
        echo -e "  ${R}0)${N} Back to Main Menu"
        echo ""
        read -p "Select Option [0-15]: " a_ch


        case $a_ch in
            1)
                echo -e "\n${Y}[*] Connected ADB Devices:${N}"
                termux-usb -l 2>/dev/null
                run_otg adb devices
                read -p "Press Enter..." ;;
            2)
                echo -e "\n${Y}[*] Connected Fastboot Devices:${N}"
                run_otg fastboot devices
                read -p "Press Enter..." ;;
            3)
                echo -e "\n${Y}[*] Device Slot & Bootloader Info:${N}"
                run_otg fastboot getvar current-slot
                run_otg fastboot getvar unlocked
                run_otg fastboot oem device-info
                read -p "Press Enter..." ;;
            4)
                echo -e "\n${Y}[*] Rebooting to Normal System...${N}"
                run_otg fastboot reboot 2>/dev/null || run_otg adb reboot
                read -p "Press Enter..." ;;
            5)
                echo -e "\n${Y}[*] Rebooting to Bootloader / Fastboot...${N}"
                run_otg adb reboot bootloader
                read -p "Press Enter..." ;;
            6)
                echo -e "\n${Y}[*] Rebooting to FastbootD...${N}"
                run_otg adb reboot fastboot 2>/dev/null || run_otg fastboot reboot fastboot
                read -p "Press Enter..." ;;
            7)
                echo -e "\n${Y}[*] Rebooting to Recovery Mode...${N}"
                run_otg adb reboot recovery
                read -p "Press Enter..." ;;
            8)
                echo -e "\n${Y}[*] Rebooting to EDL Mode...${N}"
                run_otg adb reboot edl 2>/dev/null || run_otg fastboot oem edl
                read -p "Press Enter..." ;;
            9)
                echo -e "\n${C}Example: /sdcard/Download/boot.img${N}"
                read -p "Enter Image Path: " IMG
                [ -f "$IMG" ] && run_otg fastboot boot "$IMG" || echo -e "${R}[!] File not found!${N}"
                read -p "Press Enter..." ;;
            10)
                echo -e "\n${C}Example: /sdcard/Download/magisk_boot.img${N}"
                read -p "Enter boot.img Path: " B_IMG
                [ -f "$B_IMG" ] && run_otg fastboot flash boot "$B_IMG" || echo -e "${R}[!] File not found!${N}"
                read -p "Press Enter..." ;;
            11)
                echo -e "\n${C}Example: /sdcard/Download/init_boot.img${N}"
                read -p "Enter init_boot.img Path: " IB_IMG
                [ -f "$IB_IMG" ] && run_otg fastboot flash init_boot "$IB_IMG" || echo -e "${R}[!] File not found!${N}"
                read -p "Press Enter..." ;;
            12)
                echo -e "\n${C}Example: /sdcard/Download/vendor_boot.img${N}"
                read -p "Enter vendor_boot.img Path: " VB_IMG
                [ -f "$VB_IMG" ] && run_otg fastboot flash vendor_boot "$VB_IMG" || echo -e "${R}[!] File not found!${N}"
                read -p "Press Enter..." ;;
            13)
                echo -e "\n${C}Example: /sdcard/Download/vbmeta.img${N}"
                read -p "Enter vbmeta.img Path: " VBM
                if [ -f "$VBM" ]; then
                    run_otg fastboot --disable-verity --disable-verification flash vbmeta "$VBM"
                else
                    echo -e "${R}[!] File not found!${N}"
                fi
                read -p "Press Enter..." ;;
            14)
                echo -e "\n${C}Example: /sdcard/Download/recovery.img${N}"
                read -p "Enter recovery.img Path: " REC
                [ -f "$REC" ] && run_otg fastboot flash recovery "$REC" || echo -e "${R}[!] File not found!${N}"
                read -p "Press Enter..." ;;
            15)
                echo -e "\n${C}Example: /sdcard/Download/Magisk.zip${N}"
                read -p "Enter Zip File Path: " ZIPF
                [ -f "$ZIPF" ] && run_otg adb sideload "$ZIPF" || echo -e "${R}[!] File not found!${N}"
                read -p "Press Enter..." ;;
            0) break ;;
            *) echo -e "${R}[!] Invalid option!${N}"; sleep 1 ;;
        esac
    done
}

while true; do
    banner
    echo -e "  ${G}1)${N} Master Setup 1 (Root: Magisk/KSU/APatch)"
    echo -e "  ${G}2)${N} Master Setup 2 (Non-Root & OTG Setup)"
    echo -e "  ${G}3)${N} WiFi Tools     (Scan, Speed, Info, Pass)"
    echo -e "  ${G}4)${N} ADB & Fastboot (Universal Root & Flash)"
    echo -e "  ${C}5)${N} Update Tool    (Get Latest Version)"
    echo -e "  ${R}0)${N} Exit"
    echo ""
    read -p "Choose Main Option [0-5]: " main_ch

    case $main_ch in
        1) root_setup_menu ;;
        2) nonroot_setup ;;
        3) wifi_tools_menu ;;
        4) adb_fastboot_menu ;;
        5)
            echo -e "\n${Y}[*] Updating ONIK PRO MASTER SUITE...${N}"
            bash <(echo "Y3VybCAtZnNMIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9vbmlrbTYzNDMtc3ZnL29uaWsvbWFpbi9vbmlrLnNoIC1vICRQUkVGSVgvYmluL29uaWsgJiYgY2htb2QgK3ggJFBSRUZJWC9iaW4vb25payAmJiBvbmlr" | base64 -d)
            exit 0 ;;
        0) echo -e "${C}Thank you for using MD Onik Suite!${N}"; exit 0 ;;
        *) echo -e "${R}[!] Invalid choice!${N}"; sleep 1 ;;
    esac
done
