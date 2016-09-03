# Written in VB

- Tested and working on Windows 7 clients, I suggest you trial before deploying
- Run in CMD as local Administrator
- Preapend with "cscript", example:
`cscript uac.vbs`
- If you intend to execute the above with PsExec, then I found I had to be explicit put my username despite CMD running in the same context as the same user, example:
`psexec \\hostname -h -u domain\username cmd`
