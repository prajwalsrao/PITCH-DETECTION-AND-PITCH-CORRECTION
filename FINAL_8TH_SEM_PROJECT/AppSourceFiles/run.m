c=py.chroma.chromagram("PianoChords.wav");
h=py.chroma.chordgram(c);
wsm=py.chroma.chord_sequence(h);
h1=py.chroma.smoothed_chordgram(h);
sm =py.chroma.chord_sequence(h1);
per=py.chroma.accuracy(wsm,sm);
