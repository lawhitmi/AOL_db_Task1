import pyexasol as pe

Con = pe.connect(dsn='192.168.56.101:8563',user='sys', password = 'exasol', schema = 'AOL_SCHEMA', compression=True)


R = pe.readData("SELECT 'connection works' FROM dual")
print(R)