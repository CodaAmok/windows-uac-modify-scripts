import winreg, datetime, platform

def time():
	return datetime.datetime.now().strftime("%H:%M:%S ")

def regRead(key, value):
	log.write(time() + "Checking " + value + " value\n")
	return winreg.QueryValueEx(key, value)[0]

def writeReg():
	log.write(time() + "Starting write to reg\n")
	winreg.SetValueEx(objKey, "ConsentPromptBehaviorAdmin", 0, 4, 5)
	winreg.SetValueEx(objKey, "ConsentPromptBehaviorUser", 0, 4, 3)
	winreg.SetValueEx(objKey, "EnableInstallerDetection", 0, 4, 1)
	winreg.SetValueEx(objKey, "EnableLUA", 0, 4, 1)
	winreg.SetValueEx(objKey, "EnableVirtualization", 0, 4, 1)
	winreg.SetValueEx(objKey, "PromptOnSecureDesktop", 0, 4, 1)
	winreg.SetValueEx(objKey, "ValidateAdminCodeSignatures", 0, 4, 0)
	winreg.SetValueEx(objKey, "FilterAdministratorToken", 0, 4, 0)
	log.write(time() + "Finished writing to reg\n")

def getOS():
	os = platform.win32_ver()[0]
	log.write(time() + "OS: " + os + "\n")
	return os

with open('C:\\uac.log', 'a') as log:
	log.write(time() + "Started\n")
	strKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System"
	objKey = winreg.OpenKeyEx(winreg.HKEY_LOCAL_MACHINE, strKey, 0, winreg.KEY_ALL_ACCESS)
	strOS = getOS()

	if strOS == "10":
		log.write(time() + "Found Win10, quitting\n")
	elif strOS == "8.1":
		if regRead(objKey, "EnableLUA") == 0:
			log.write(time() + "UAC is disabled\n")
			writeReg()
		else:
			log.write(time() + "UAC is enabled, quitting\n")
	elif strOS == "8":
		log.write(time() + "Found Win8, quitting\n")
	elif strOS == "7":
		log.write(time() + "Found Win7, quitting\n")
	elif strOS == "Vista":
		log.write(time() + "Found Vista, quitting\n")
	elif strOS == "XP":
		log.write(time() + "Found XP, quitting\n")
	else:
		log.write(time() + "Unknown OS, " + strOS + ", quitting\n")

	winreg.CloseKey(objKey)
	log.write(time() + "Finished\n")