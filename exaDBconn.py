import pyexasol as pe

def genDBCursor():
    C=pe.connect(dsn='192.168.56.102:8563',user='sys',password='exasol')
    return C