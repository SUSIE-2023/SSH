#!/bin/bash

fix_stunnel_xray() {
    echo "กรุณากรอกข้อมูลสำหรับใบรับรอง SSL (กด Enter ข้าม Organization และ Unit ได้)"

    read -p "Country Code (TH): " country
    read -p "State/Province (Bangkok): " state
    read -p "City (Bangkok): " city
    read -p "Organization (Enter): " org
    read -p "Organizational Unit (Enter): " unit
    read -p "Common Name (Hostname): " common_name
    read -p "Email Address: " email

    # ถ้า org หรือ unit เป็นค่าว่าง ให้ใช้ "None"
    org=${org:-None}
    unit=${unit:-None}

    echo "กำลังสร้างใบรับรอง SSL..."
    openssl req -x509 -newkey rsa:2048 -keyout /etc/xray/xray.key -out /etc/xray/xray.crt -days 365 \
        -subj "/C=$country/ST=$state/L=$city/O=$org/OU=$unit/CN=$common_name/emailAddress=$email"

    echo "กำลังตั้งค่าสิทธิ์ให้กับไฟล์ใบรับรอง..."
    chmod 644 /etc/xray/xray.crt
    chmod 600 /etc/xray/xray.key

    echo "กำลังรีสตาร์ทบริการ stunnel5 และ xray..."
    systemctl restart stunnel5
    systemctl restart xray

    echo "กำลังตรวจสอบสถานะของบริการ stunnel5..."
    systemctl status stunnel5

    echo "กำลังตรวจสอบการฟังพอร์ตของ stunnel5..."
    netstat -tulnp | grep stunnel5

    echo "การติดตั้งและตั้งค่าเสร็จสมบูรณ์!"
}

fix_stunnel_xray
