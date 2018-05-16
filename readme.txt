Step 1: Make Database
Listen to a song, and write down its notes and chords.
data\**.txt, where ** is a number.
Format of a file is shown below.

Bars: * * * // The 3 numbers are the bars of Verse, Prechorus, and Refrain.
Bias: * // How many biases are there. Followed by n lines, each is a bias.
* * * // Three numbers. The first one is Bias
* * * // (How many semitones should you DECREASE to make the song C major or A minor)
..... // The 2nd and 3rd numbers are the bar number that this bias begins and ends.
Notes:
* * * * * * * * | * * // Each line is a bar. 8 numbers before the "|", and 2 after it.
// The 8 numbers are the 8 8th notes in the bar.
// If it is a rest note, or a previous note longer than 8th, then write "-" .
// If there is 16th note somewhere:
// then write that 8th note as "[* *]" to represent the 16th notes.
// Each number before the "|" represent a note's pitch in the melody.
// 1=central C, 2=D, 3=E, etc. And the bias does not apply now.
// Sharp(#) is +0.5 to the number, and Flat (b) is -0.5 to the number.
// For example, 1.5=C#=Db, 5.5=G#=Ab.
// 3.5 and 7.5 (0.5) are not allowed. Instead, 4=E#=F, 3=Fb=E, etc.
// +7 for an octave higher, and -7 for an octave lower.
// For example, 0 for lower B, -1.5 for lower G#, etc.
// The 2 numbers after the "|" represent the chords.
// Only majors and minors are considered.
// 1, 1.5, 2, ..., 7 represents the 12 major chords, and opposite number for minor chords.
// For example, 4=F, 5=G=G7, -2=Dm.
// Each chord is half note length. If the two chords are the same in a bar, write it twice.

After that, open "main_dataprep.m" in Matlab.
Change variable "songs0" to the number of your first new data file.
Change "songs1" to the number of your last file.
Run "main_dataprep.m".

==========================================

Step 2: Train RNN

Open "main_rnn_train.m".
Change your desired database:
Change "songs" to a vector of song numbers you want, such as [4 6 8 9 12].
Or you leave it to be a scalar n, which means all songs in (1:n) are considered.
You may adjust the epochs you want to run, and the alpha ("alp") in exponential equation.
Smaller alpha means more diversity. I recommend 0.1 or 0.05.
Run "main_rnn_train.m".

==========================================

Step 3: Compose your song!

Open "main.m".
Change your needs:
"alp" is the alpha.

Copy rate:
The likelihood is multiplied by copy rate for the same output of bar you want to copy from.
"*_cop_rate" (*=r,c,m) is the copy rate for Rhythm, Chord and Melody.
I recommend copy rate to be 3 to 5.
You can change the details in the "% copy" block.
The default is to copy the (n-8)-th bar if it is NOT the first 8 bars of a (verse, prechorus, refrain).
"pref_rate" is the preferred rate for melody.

Melody Preference:
The likelihood is multiplied by "pref_rate" if a pitch falls in a certain range.
I recommend the rate to be 1.5 to 2.
You can change the details in the "% melody preference" block.
The default is (lower to central G) for verse; (central to higher C) for prechorus;
(central to higher G) for refrain.
Note that 1=lower C, 13=central C, and each seminote is +1.

Melody Harmony:
The likelihood is multiplied by "har_rate" if a pitch is harmonic to the current chord.
(If it is equal to, or only octaves different from, a key in the chord.) 
I recommend the rate to be 1.5 to 2.

Melody Neighbour:
The likelihood is multiplied by "nei_rate" if a pitch is in certain range of the previous one.
The default is within 2 semitones and different from the previous one.
I recommend the rate to be 1.5 to 2.
The adjustment is not opened in "main.m" yet, you can find it in "rnn_gen_m.m".

Rhythm preference:
"rpref_rate*" (*=v,p,r) is the rhythm preference for Verse, Prechorus and Refrain.
It multiplies the likelihood for a 8th note to be active (new note).
The default is 1.0 for v, 1.5 for p, and 2.0 for r.

Length:
"N*" (*=v,p,r) is the length (bars) of each part of a song: Verse, Prechorus and Refrain
The default is 16, 8 and 16.

Miscellaneous:
"bpm": How many 4th notes are there in a minute.
"fs": Don't you know this?
"f0": What is the frequency (Hz) of central C.
(220=normal, 330=G major, 440=an octave higher, etc.)
"cm_rate": What is the maximum amplitude of chord over melody.
(Or maybe inversed? But I set its default to 1.)
"dec_l": For a long note, after how many 8th notes will it exponentially decay to 1/e.
(default is 4.)
"sm_l": How long is the ascending part of a note. (default is f0/10000)
"wws": What's the weight of each harmony for each note?
It will be auto-normalized. Don't worry.
The default is [1.5 0.5 0.7 0.6 0.4 0.4 0.3 0.1] for piano.

At last, run "main.m"!