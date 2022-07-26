import subprocess

def open_sheet(filename):
    subprocess.Popen(["MidiSheetMusic-2.6.2.exe",filename])