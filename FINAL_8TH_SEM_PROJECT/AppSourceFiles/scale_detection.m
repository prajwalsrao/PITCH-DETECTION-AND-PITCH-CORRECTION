function [detected_scale note_detected] = scale_detection(xt , Fs)
    music_note = py.dict(pyargs('C0',16.35,'C#0',17.32,'D0',18.35,'D#0',19.45,'E0',20.6,'F0',21.83,'F#0',23.12,'G0',24.50,'G#0',25.96,'A0',27.50,'A#0',29.14,'B0',30.87,'C1',32.7,'C#1',34.65,'D1',36.71,'D#1',38.89,'E1',41.2,'F1',46.25,'F#1',46.25,'G1',49,'G#1',51.91,'A1',55,'A#1',58.27,'B1',61.74,'C2',65.41,'C#2',69.30,'D2',73.42,'D#2',77.78,'E2',82.41,'F2',87.31,'F#2',92.5,'G2',98,'G#2',103.83,'A2',110,'A#2',116.54,'B2',123.47,'C3',130.81,'C#3',138.59,'D3',146.83,'D#3',155.56,'E3',164.81,'F3',174.61,'F#3',185,'G3',196,'G#3',207.65,'A3',220,'A#3',233.08,'B3',246.94,'C4',261.63,'C#4',277.18,'D4',293.66,'D#4',311.13,'E4',329.63,'F4',349.23,'F#4',370,'G4',392,'G#4',415.30,'A4',440,'A#4',466.16,'B4',493.88,'C5',523.25,'C#5',554.37,'D5',587.33,'D#5',622.25,'E5',659.25,'F5',698.46,'F#5',740,'G5',784,'G#5',830.61,'A5',880,'A#5',932.33,'B5',987.77,'C6',1046.5,'C#6',1108.73,'D6',1174.67,'D#6',1244.51,'E6',1318.51,'F6',1396.91,'F#6',1480.0,'G6',1568,'G#6',1661.22,'A6',1760,'A#6',1864.67,'B6',1975.53));
    music_scale = py.dict(pyargs('C Major',py.list({'C','D','E','F','G','A','B'}),'C# Major',py.list({'C#','D#','F','F#','G#','A#','C'}),'D Major',py.list({'D','E','F#','G','A','B','C#'}),'D# Major',py.list({'D#','F','G','G#','A','C','D'}),'E Major',py.list({'E','F#','G#','A','B','C#','D#'}),'F Major',py.list({'F','G','A','A#','C','D','E'}),'F# Major',py.list({'F#','G#','A#','B','C#','D#','F'}),'G Major',py.list({'G','A','B','C','D','E','F#'}),'G# Major',py.list({'G#','A#','C','C#','D#','F','G'}),'A Major',py.list({'A','B','C#','D','E','F#','G#'}),'A# Major',py.list({'A#','C','D','D#','F','G','A'}),'B Major',py.list({'B','C#','D#','E','F#','G#','A#'}),'E Major',py.list({'E','F#','G#','A','B','C#','D#'}),'C Minor',py.list({'C','D','D#','F','G','G#','A#'}),'C# Minor',py.list({'C#','D#','E','F#','G#','A','B'}),'D Minor',py.list({'D','E','F','G','A','A#','C#'}),'D# Minor',py.list({'D#','F','F#','G#','A#','B','C#'}),'E Minor',py.list({'E','F#','G','A','B','C','D'}),'F Minor',py.list({'F','G','G#','A#','C','C#','D#'}),'F# Minor',py.list({'F#','G#','A','B','C#','D','E'}),'G Minor',py.list({'G','A','A#','C','D','D#','F'}),'G# Minor',py.list({'G#','A#','B','C#','D#','E','F#'}),'A Minor',py.list({'A','B','C','D','E','F','G'}),'A# Minor',py.list({'A#','C','C#','D#','F','F#','G#'}),'B Minor',py.list({'B','C#','D','E','F#','G','A'}),'C Major Pentatonic',py.list({'C','D','E','G','A'}),'C# Major Pentatonic',py.list({'C#','D#','F','G#','A#'}),'D Major Pentatonic',py.list({'D','E','F#','A','B'}),'D# Major Pentatonic',py.list({'D#','F','G','A#','C'}),'E Major Pentatonic',py.list({'E','F#','G#','B','C#'}),'F Major Pentatonic',py.list({'F','G','A','C','D'}),'F# Major Pentatonic',py.list({'F#','G#','A#','C#','D#'}),'G Major Pentatonic',py.list({'G','A','B','D','E'}),'G# Major Pentatonic',py.list({'G#','A#','C','D#','F'}),'A Major Pentatonic',py.list({'A','B','C#','E','F#'}),'A# Major Pentatonic',py.list({'A#','C','D','F','G'}),'B Major Pentatonic',py.list({'B','C#','D#','F#','G#'}),'C Minor Pentatonic',py.list({'C','D#','F','G','A#'}),'C# Minor Pentatonic',py.list({'C#','E','F#','G#','B'}),'D Minor Pentatonic',py.list({'D','F','G','A','C'}),'D# Minor Pentatonic',py.list({'D#','F#','G#','A#','C#'}),'E Minor Pentatonic',py.list({'E','G','A','B','D'}),'F Minor Pentatonic',py.list({'F','G#','A#','C','D#'}),'F# Minor Pentatonic',py.list({'F#','A','B','C#','E'}),'G Minor Pentatonic',py.list({'G','A#','C','D','F'}),'G# Minor Pentatonic',py.list({'G#','B','C#','D#','F#'}),'A Minor Pentatonic',py.list({'A','C','D','E','G'}),'A# Minor Pentatonic',py.list({'A#','C#','D#','F','G#'}),'B Minor Pentatonic',py.list({'B','D','E','F#','A'})));
    note = py.list({'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'});
    [p,t] = YinAlgo(xt,Fs);
    scales = py.list({'NULL','NULL','NULL','NULL'});
    repeat = 4;
    detected_notes = py.list({});
    note_detected = '';
    for i = 1 :2048:length(p)
        if(((music_note{'A0'} * 2^(-1/24) < p(i))&(music_note{'A0'} * 2^(1/24) > p(i)))|((music_note{'A1'} * 2^(-1/24) < p(i))&(music_note{'A1'} * 2^(1/24) > p(i)))|((music_note{'A2'} * 2^(-1/24) < p(i))&(music_note{'A2'} * 2^(1/24) > p(i)))|((music_note{'A3'} * 2^(-1/24) < p(i))&(music_note{'A3'} * 2^(1/24) > p(i)))|((music_note{'A4'} * 2^(-1/24) < p(i))&(music_note{'A4'} * 2^(1/24) > p(i)))|((music_note{'A5'} * 2^(-1/24) < p(i))&(music_note{'A5'} * 2^(1/24) > p(i)))|((music_note{'A6'} * 2^(-1/24) < p(i))&(music_note{'A6'} * 2^(1/24) > p(i))))
            scales.append('A');
            if  (scales(repeat-2) == scales(repeat -1)) & (scales(repeat -1) == note(1)) &(scales.count('A') == 4)
                detected_notes.append('A');
                note_detected = append(note_detected,'A ');
            end

        elseif(((music_note{'A#0'} * 2^(-1/24) < p(i))&(music_note{'A#0'} * 2^(1/24) > p(i)))|((music_note{'A#1'} * 2^(-1/24) < p(i))&(music_note{'A#1'} * 2^(1/24) > p(i)))|((music_note{'A#2'} * 2^(-1/24) < p(i))&(music_note{'A#2'} * 2^(1/24) > p(i)))|((music_note{'A#3'} * 2^(-1/24) < p(i))&(music_note{'A#3'} * 2^(1/24) > p(i)))|((music_note{'A#4'} * 2^(-1/24) < p(i))&(music_note{'A#4'} * 2^(1/24) > p(i)))|((music_note{'A#5'} * 2^(-1/24) < p(i))&(music_note{'A#5'} * 2^(1/24) > p(i)))|((music_note{'A#6'} * 2^(-1/24) < p(i))&(music_note{'A#6'} * 2^(1/24) > p(i))))
            scales.append('A#');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(2))& (scales.count('A#') == 4)
                detected_notes.append('A#');
                note_detected = append(note_detected,'A# ');
            end

        elseif(((music_note{'B0'} * 2^(-1/24) < p(i))&(music_note{'B0'} * 2^(1/24) > p(i)))|((music_note{'B1'} * 2^(-1/24) < p(i))&(music_note{'B1'} * 2^(1/24) > p(i)))|((music_note{'B2'} * 2^(-1/24) < p(i))&(music_note{'B2'} * 2^(1/24) > p(i)))|((music_note{'B3'} * 2^(-1/24) < p(i))&(music_note{'B3'} * 2^(1/24) > p(i)))|((music_note{'B4'} * 2^(-1/24) < p(i))&(music_note{'B4'} * 2^(1/24) > p(i)))|((music_note{'B5'} * 2^(-1/24) < p(i))&(music_note{'B5'} * 2^(1/24) > p(i)))|((music_note{'B6'} * 2^(-1/24) < p(i))&(music_note{'B6'} * 2^(1/24) > p(i))))
           scales.append('B'); 
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(3))& (scales.count('B') == 4)
                detected_notes.append('B');
                note_detected = append(note_detected,'B ');
            end

        elseif(((music_note{'C0'} * 2^(-1/24) < p(i))&(music_note{'C0'} * 2^(1/24) > p(i)))|((music_note{'C1'} * 2^(-1/24) < p(i))&(music_note{'C1'} * 2^(1/24) > p(i)))|((music_note{'C2'} * 2^(-1/24) < p(i))&(music_note{'C2'} * 2^(1/24) > p(i)))||((music_note{'C3'} * 2^(-1/24) < p(i))&(music_note{'C3'} * 2^(1/24) > p(i)))|((music_note{'C4'} * 2^(-1/24) < p(i))&(music_note{'C4'} * 2^(1/24) > p(i)))|((music_note{'C5'} * 2^(-1/24) < p(i))&(music_note{'C5'} * 2^(1/24) > p(i)))|((music_note{'C6'} * 2^(-1/24) < p(i))&(music_note{'C6'} * 2^(1/24) > p(i))))
            scales.append('C');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(4))& (scales.count('C') == 4)
                detected_notes.append('C');
                note_detected = append(note_detected,'C ');
            end

        elseif(((music_note{'C#0'} * 2^(-1/24) < p(i))&(music_note{'C#0'} * 2^(1/24) > p(i)))|((music_note{'C#1'} * 2^(-1/24) < p(i))&(music_note{'C#1'} * 2^(1/24) > p(i)))|((music_note{'C#2'} * 2^(-1/24) < p(i))&(music_note{'C#2'} * 2^(1/24) > p(i)))|((music_note{'C#3'} * 2^(-1/24) < p(i))&(music_note{'C#3'} * 2^(1/24) > p(i)))|((music_note{'C#4'} * 2^(-1/24) < p(i))&(music_note{'C#4'} * 2^(1/24) > p(i)))|((music_note{'C#5'} * 2^(-1/24) < p(i))&(music_note{'C#5'} * 2^(1/24) > p(i)))|((music_note{'C#6'} * 2^(-1/24) < p(i))&(music_note{'C#6'} * 2^(1/24) > p(i))))
            scales.append('C#');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(5))& (scales.count('C#') == 4)
                detected_notes.append('C#');
                note_detected = append(note_detected,'C# ');
            end

        elseif(((music_note{'D0'} * 2^(-1/24) < p(i))&(music_note{'D0'} * 2^(1/24) > p(i)))|((music_note{'D1'} * 2^(-1/24) < p(i))&(music_note{'D1'} * 2^(1/24) > p(i)))|((music_note{'D2'} * 2^(-1/24) < p(i))&(music_note{'D2'} * 2^(1/24) > p(i)))|((music_note{'D3'} * 2^(-1/24) < p(i))&(music_note{'D3'} * 2^(1/24) > p(i)))|((music_note{'D4'} * 2^(-1/24) < p(i))&(music_note{'D4'} * 2^(1/24) > p(i)))|((music_note{'D5'} * 2^(-1/24) < p(i))&(music_note{'D5'} * 2^(1/24) > p(i)))|((music_note{'D6'} * 2^(-1/24) < p(i))&(music_note{'D6'} * 2^(1/24) > p(i))))
            scales.append('D');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(6))& (scales.count('D') == 4)
                detected_notes.append('D');
                note_detected = append(note_detected,'D ');
            end

         elseif(((music_note{'D#0'} * 2^(1/24) > p(i)))|((music_note{'D#1'} * 2^(-1/24) < p(i))&(music_note{'D#1'} * 2^(1/24) > p(i)))|((music_note{'D#2'} * 2^(-1/24) < p(i))&(music_note{'D#2'} * 2^(1/24) > p(i)))|((music_note{'D#3'} * 2^(-1/24) < p(i))&(music_note{'D#3'} * 2^(1/24) > p(i)))|((music_note{'D#4'} * 2^(-1/24) < p(i))&(music_note{'D#4'} * 2^(1/24) > p(i)))|((music_note{'D#5'} * 2^(-1/24) < p(i))&(music_note{'D#5'} * 2^(1/24) > p(i)))|((music_note{'D#6'} * 2^(-1/24) < p(i))&(music_note{'D#6'} * 2^(1/24) > p(i))))   
            scales.append('D#');
             if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(7)) & (scales.count('D#') == 4)
                detected_notes.append('D#');
                note_detected = append(note_detected,'D# ');
            end

        elseif(((music_note{'E0'} * 2^(-1/24) < p(i))&(music_note{'E0'} * 2^(1/24) > p(i)))|((music_note{'E1'} * 2^(-1/24) < p(i))&(music_note{'E1'} * 2^(1/24) > p(i)))|((music_note{'E2'} * 2^(-1/24) < p(i))&(music_note{'E2'} * 2^(1/24) > p(i)))|((music_note{'E3'} * 2^(-1/24) < p(i))&(music_note{'E3'} * 2^(1/24) > p(i)))|((music_note{'E4'} * 2^(-1/24) < p(i))&(music_note{'E4'} * 2^(1/24) > p(i)))|((music_note{'E5'} * 2^(-1/24) < p(i))&(music_note{'E5'} * 2^(1/24) > p(i)))|((music_note{'E6'} * 2^(-1/24) < p(i))&(music_note{'E6'} * 2^(1/24) > p(i))))
            scales.append('E');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(8)) & (scales.count('E') == 4)
                detected_notes.append('E');
                note_detected = append(note_detected,'E ');
            end

        elseif(((music_note{'F0'} * 2^(-1/24) < p(i))&(music_note{'F0'} * 2^(1/24) > p(i)))|((music_note{'F1'} * 2^(-1/24) < p(i))&(music_note{'F1'} * 2^(1/24) > p(i)))|((music_note{'F2'} * 2^(-1/24) < p(i))&(music_note{'F2'} * 2^(1/24) > p(i)))|((music_note{'F3'} * 2^(-1/24) < p(i))&(music_note{'F3'} * 2^(1/24) > p(i)))|((music_note{'F4'} * 2^(-1/24) < p(i))&(music_note{'F4'} * 2^(1/24) > p(i)))|((music_note{'F5'} * 2^(-1/24) < p(i))&(music_note{'F5'} * 2^(1/24) > p(i)))|((music_note{'F6'} * 2^(-1/24) < p(i))&(music_note{'F6'} * 2^(1/24) > p(i))))
            scales.append('F');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(9)) & (scales.count('F') == 4)
                detected_notes.append('F');
                note_detected = append(note_detected,'F ');
            end

        elseif(((music_note{'F#0'} * 2^(-1/24) < p(i))&(music_note{'F#0'} * 2^(1/24) > p(i)))|((music_note{'F#1'} * 2^(-1/24) < p(i))&(music_note{'F#1'} * 2^(1/24) > p(i)))|((music_note{'F#2'} * 2^(-1/24) < p(i))&(music_note{'F#2'} * 2^(1/24) > p(i)))|((music_note{'F#3'} * 2^(-1/24) < p(i))&(music_note{'F#3'} * 2^(1/24) > p(i)))|((music_note{'F#4'} * 2^(-1/24) < p(i))&(music_note{'F#4'} * 2^(1/24) > p(i)))|((music_note{'F#5'} * 2^(-1/24) < p(i))&(music_note{'F#5'} * 2^(1/24) > p(i)))|((music_note{'F#6'} * 2^(-1/24) < p(i))&(music_note{'F#6'} * 2^(1/24) > p(i))))
            scales.append('F#');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(10))& (scales.count('F#') == 4)
                detected_notes.append('F#');
                note_detected = append(note_detected,'F# ');
            end

        elseif(((music_note{'G0'} * 2^(-1/24) < p(i))&(music_note{'G0'} * 2^(1/24) > p(i)))|((music_note{'G1'} * 2^(-1/24) < p(i))&(music_note{'G1'} * 2^(1/24) > p(i)))|((music_note{'G2'} * 2^(-1/24) < p(i))&(music_note{'G2'} * 2^(1/24) > p(i)))|((music_note{'G3'} * 2^(-1/24) < p(i))&(music_note{'G3'} * 2^(1/24) > p(i)))|((music_note{'G4'} * 2^(-1/24) < p(i))&(music_note{'G4'} * 2^(1/24) > p(i)))|((music_note{'G5'} * 2^(-1/24) < p(i))&(music_note{'G5'} * 2^(1/24) > p(i)))|((music_note{'G6'} * 2^(-1/24) < p(i))&(music_note{'G6'} * 2^(1/24) > p(i))))
          scales.append('G');  
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(11)) & (scales.count('G') == 4)
                detected_notes.append('G');
                note_detected = append(note_detected,'G ');
            end

        elseif(((music_note{'G#0'} * 2^(-1/24) < p(i))&(music_note{'G#0'} * 2^(1/24) > p(i)))|((music_note{'G#1'} * 2^(-1/24) < p(i))&(music_note{'G#1'} * 2^(1/24) > p(i)))|((music_note{'G#2'} * 2^(-1/24) < p(i))&(music_note{'G#2'} * 2^(1/24) > p(i)))|((music_note{'G#3'} * 2^(-1/24) < p(i))&(music_note{'G#3'} * 2^(1/24) > p(i)))|((music_note{'G#4'} * 2^(-1/24) < p(i))&(music_note{'G#4'} * 2^(1/24) > p(i)))|((music_note{'G#5'} * 2^(-1/24) < p(i))&(music_note{'G#5'} * 2^(1/24) > p(i)))|((music_note{'G#6'} * 2^(-1/24) < p(i))&(music_note{'G#6'} * 2^(1/24) > p(i))))
            scales.append('G#');
            if (scales(repeat-2) == scales(repeat-1))&(scales(repeat-1) == note(12)) & (scales.count('G#') == 4)
                detected_notes.append('G#');
                note_detected = append(note_detected,'G# ');
            end

         else
             scales.append('');
        end

        repeat = repeat + 1;

    end
    
    if music_scale{'C Major'} == detected_notes
        detected_scale = 'C MAJOR';

    elseif music_scale{'C# Major'} == detected_notes
        detected_scale = 'C# MAJOR';

    elseif music_scale{'D Major'} == detected_notes
        detected_scale = 'D MAJOR';

    elseif music_scale{'D# Major'} == detected_notes
        detected_scale = 'D# MAJOR';

    elseif music_scale{'E Major'} == detected_notes
        detected_scale = 'E MAJOR';

    elseif music_scale{'F Major'} == detected_notes
        detected_scale = 'F MAJOR';

    elseif music_scale{'F# Major'} == detected_notes
        detected_scale = 'F# MAJOR';

    elseif music_scale{'G Major'} == detected_notes
        detected_scale = 'G MAJOR';

    elseif music_scale{'G# Major'} == detected_notes
        detected_scale = 'G# MAJOR';

    elseif music_scale{'A Major'} == detected_notes
        detected_scale = 'A MAJOR';

    elseif music_scale{'A# Major'} == detected_notes
        detected_scale = 'A# MAJOR';

    elseif music_scale{'B Major'} == detected_notes
        detected_scale = 'B MAJOR';

    elseif music_scale{'C Minor'} == detected_notes
        detected_scale = 'C MINOR';

    elseif music_scale{'C# Minor'} == detected_notes
        detected_scale = 'C# MINOR';

    elseif music_scale{'D Minor'} == detected_notes
        detected_scale = 'D MINOR';

    elseif music_scale{'D# Minor'} == detected_notes
        detected_scale = 'D# MINOR';

    elseif music_scale{'E Minor'} == detected_notes
        detected_scale = 'E MINOR';

    elseif music_scale{'F Minor'} == detected_notes
        detected_scale = 'F MINOR';

    elseif music_scale{'F# Minor'} == detected_notes
        detected_scale = 'F# MINOR';

    elseif music_scale{'G Minor'} == detected_notes
        detected_scale = 'G MINOR';

    elseif music_scale{'G# Minor'} == detected_notes
        detected_scale = 'G# MINOR';
        
    elseif music_scale{'A Minor'} == detected_notes
        detected_scale = 'A MINOR';

    elseif music_scale{'A# Minor'} == detected_notes
        detected_scale = 'A# MINOR';

    elseif music_scale{'B Minor'} == detected_notes
        detected_scale = 'B MINOR';

    elseif music_scale{'C Major Pentatonic'} == detected_notes
        detected_scale = 'C MAJOR PENTATONIC';

    elseif music_scale{'C# Major Pentatonic'} == detected_notes
        detected_scale = 'C# MAJOR PENTATONIC';

    elseif music_scale{'D Major Pentatonic'} == detected_notes
        detected_scale = 'D MAJOR PENTATONIC';

    elseif music_scale{'D# Major Pentatonic'} == detected_notes
        detected_scale = 'D# MAJOR PENTATONIC';

    elseif music_scale{'E Major Pentatonic'} == detected_notes
        detected_scale = 'E MAJOR PENTATONIC';

    elseif music_scale{'F Major Pentatonic'} == detected_notes
        detected_scale = 'F MAJOR PENTATONIC';

    elseif music_scale{'F# Major Pentatonic'} == detected_notes
        detected_scale = 'F# MAJOR PENTATONIC';

    elseif music_scale{'G Major Pentatonic'} == detected_notes
        detected_scale = 'G MAJOR PENTATONIC';

    elseif music_scale{'G# Major Pentatonic'} == detected_notes
        detected_scale = 'G# MAJOR PENTATONIC';

    elseif music_scale{'A Major Pentatonic'} == detected_notes
        detected_scale = 'A MAJOR PENTATONIC';

    elseif music_scale{'A# Major Pentatonic'} == detected_notes
        detected_scale = 'A# MAJOR PENTATONIC';

    elseif music_scale{'B Major Pentatonic'} == detected_notes
        detected_scale = 'B MAJOR PENTATONIC';

    elseif music_scale{'C Minor Pentatonic'} == detected_notes
        detected_scale = 'C MINOR PENTATONIC';

    elseif music_scale{'C# Minor Pentatonic'} == detected_notes
        detected_scale = 'C# MINOR PENTATONIC';

    elseif music_scale{'D Minor Pentatonic'} == detected_notes
        detected_scale = 'D MINOR PENTATONIC';
        
    elseif music_scale{'D# Minor Pentatonic'} == detected_notes
        detected_scale = 'D# MINOR PENTATONIC';

    elseif music_scale{'E Minor Pentatonic'} == detected_notes
        detected_scale = 'E MINOR PENTATONIC';

    elseif music_scale{'F Minor Pentatonic'} == detected_notes
        detected_scale = 'F MINOR PENTATONIC';

    elseif music_scale{'F# Minor Pentatonic'} == detected_notes
        detected_scale = 'F# MINOR PENTATONIC';

    elseif music_scale{'G Minor Pentatonic'} == detected_notes
        detected_scale = 'G MINOR PENTATONIC';

    elseif music_scale{'G# Minor Pentatonic'} == detected_notes
        detected_scale = 'G# MINOR PENTATONIC';

    elseif music_scale{'A Minor Pentatonic'} == detected_notes
        detected_scale = 'A MINOR PENTATONIC';

    elseif music_scale{'A# Minor Pentatonic'} == detected_notes
        detected_scale = 'A# MINOR PENTATONIC';
        
    elseif music_scale{'B Minor Pentatonic'} == detected_notes
        detected_scale = 'B MINOR PENTATONIC';
    
    else
        detected_scale = 'NONE OF THE STANDARD SCALE';
    end
end
