# Outbound Email module
# Credit goes to Joska de Langen
# https://realpython.com/python-send-email/#option-2-setting-up-a-local-smtp-server

import smtplib, ssl

# Create a secure SSL context
context = ssl.create_default_context()

def send_email(sender_email, email_server, receiver_email, port, password, message):
    if message is not None:
        with smtplib.SMTP_SSL(email_server, port, context=context) as server:
            server.login(sender_email, password)
            server.sendmail(sender_email, receiver_email, message)
            return print("Outbound Email Sent")
            

# Below has been left here for reference, not used in WebScraper
"""
sender_email = "you@gmail.com"  # Enter your address
receiver_email = "them@gmail.com"  # Enter receiver address
email_server = "smtp.gmail.com"
port = 465  # For SSL
password = input("Type your password and press enter: ")
"""
