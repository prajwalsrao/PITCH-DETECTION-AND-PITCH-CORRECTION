from parameters import *
import librosa
import librosa.display
import matplotlib.pyplot as plt

def chromagram(file):

    sr=44100
    
    # reads audio file starting at [offset] and lasts [duration] seconds
    y, sr = librosa.load(file, sr=sr, offset=offset, duration=duration)
    print(y)
    print(len(y))

    # Harmonic content extraction
    y_harmonic, y_percussive = librosa.effects.hpss(y)
    print(y_harmonic)
    print(len(y_harmonic))
    print(y_percussive)
    print(len(y_percussive))

    # use Constant Q Transform to calculate Pitch Class Profile (PCP), normalized
    chromagram = librosa.feature.chroma_cqt(y=y_harmonic, sr=sr, hop_length=hop_length)

    


def generate_template():
    template = {}
    majors = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    minors = ['Cm', 'C#m', 'Dm', 'D#m', 'Em', 'Fm', 'F#m', 'Gm', 'G#m', 'Am', 'A#m', 'Bm']

    # template for C and Cm
    tc = [1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1]
    tcm = [1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0]
    shifted = 0

    for chord in majors:
        template[chord] = tc[12 - shifted:] + tc[:12 - shifted]
        shifted += 1

    for chord in minors:
        template[chord] = tcm[12 - shifted:] + tcm[:12 - shifted]
        shifted += 1

    # template for no chords
    tnc = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    template["NC"] = tnc

    return template


from parameters import *
from chromagram import *
import librosa
import librosa.display
import numpy as np
from scipy.stats import mode

def generate_template():
    template = {}
    majors = ["C","Db","D","Eb","E","F","F#","G","Ab","A","Bb","B"]
    minors = ["Cm","Dbm","Dm","Ebm","Em","Fm","F#m","Gm","Abm","Am","Bbm","Bm"]

    # template for C and Cm
    tc = [1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1]
    tcm = [1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0]
    shifted = 0

    for chord in majors:
        template[chord] = tc[12 - shifted:] + tc[:12 - shifted]
        shifted += 1

    for chord in minors:
        template[chord] = tcm[12 - shifted:] + tcm[:12 - shifted]
        shifted += 1

    # template for no chords
    tnc = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    template["NC"] = tnc

    return template

def cossim(u, v):
   
    return np.dot(u, v) / (np.linalg.norm(u) * np.linalg.norm(v))

def chordgram(C):
    
    frames = C.shape[1]

    # initialize
    template = generate_template()
    chords = list(template.keys())
    chroma_vectors = np.transpose(C)
    # chordgram
    H = []

    for n in np.arange(frames):
        cr = chroma_vectors[n]
        sims = []

        for chord in chords:
            t = template[chord]
            # calculate cos sim, add weight
            if chord == "NC":
                sim = cossim(cr, t) * 0.7
            else:
                sim = cossim(cr, t)
            sims += [sim]
        H += [sims]
    H = np.transpose(H)

    

    return H

def smoothing(s):
    
    w = 15
    news = [0] * len(s)
    for k in np.arange(w, len(s) - w):
        m = mode([s[i] for i in range(k - w // 2, k + w // 2 + 1)])[0][0]
        news[k] = m
    return news

def smoothed_chordgram(H):
    
    chords = H.shape[0]
    H1 = []

    for n in np.arange(chords):
        H1 += [smoothing(H[n])]

    H1 = np.array(H1)
    return H1
    
def chord_sequence(H):
   
    template = generate_template()
    chords = list(template.keys())

    frames = H.shape[1]
    H = np.transpose(H)
    R = []

    for n in np.arange(frames):
        index = np.argmax(H[n])
        if H[n][index] == 0.0:
            chord = "NC"
        else:
            chord = chords[index]

        R += [chord]

    return R

def tostring_chords(input):
    string = ""
    for r in input:
        if r == "NC":
            string += " -"
        else:
            string += " " + r
    return string

def accuracy(R,R1):
    d=[]
    count=0
    for i in range(len(R)):
        if R[i]==R1[i]:
            d.append(1)
            count+=1
        else:
            d.append(0)

   
    acc=float(100-(count/len(R)*100))
    print(acc, '%')
    return acc
