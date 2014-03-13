import re
import mechanize
import sys



username = sys.argv[1]
password = sys.argv[2]
email = sys.argv[3]
pin = sys.argv[4]
coin = sys.argv[5]
br = mechanize.Browser()

response = br.open("http://jarod120.myvnc.com/MPOS_" + coin + "/public/index.php?page=register")
#print response.read()

br.form = list(br.forms())[0]

#for control in br.form.controls:
#    print control
#    print "type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

username_control = br.form.find_control("username")
username_control.value=username

password1_control = br.form.find_control("password1")
password1_control.value = password

password2_control = br.form.find_control("password2")
password2_control.value = password

email1_control = br.form.find_control("email1")
email1_control.value = email

email2_control = br.form.find_control("email2")
email2_control.value = email

pin_control = br.form.find_control("pin")
pin_control.value = pin

br.form.find_control("tac").items[0].selected=True
#tac_control.value=True

print "Ready to submit"

response = br.submit()

print response.read()


