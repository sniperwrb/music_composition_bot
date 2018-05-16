% Parameters for prediction
alp=0.1;
r_cop_rate=5; % probability multiplier when copied, for rhythm
c_cop_rate=4; % for chord
m_cop_rate=3; % for melody
pref_rate=2.0; % probability multiplier when preferred
har_rate=2.0; % probability multiplier when harmonized
nei_rate=1.5; % Prob multiplier when a melody note is within 2 semitones from the previous one
rpref_ratev=1.0; % verse, preferred relative intensity of rhythm
rpref_ratep=1.5; % prechorus
rpref_rater=2.0; % refrain

% Length of each music component
Nv=16; % verse length (in bars)
Np=8; % prechorus
Nr=16; % refrain
N=Nv+Np+Nr;

% Parameter for wavfile construction from notes
bpm=160;
fs=16000;
cm_rate=2; %the rate of overall chord amplitude over melody amplitude
dec_l=4; % after [*] eighth notes it will decay to 1/e
f0=220;
sm_l=f0/10000; % smoothing length 1/4 eighth notes at beginning and end
wws=[1.5 0.5 0.7 0.6 0.4 0.4 0.3 0.1];
% weight of each harmony

% copy
cop=zeros(1,N);
for i=9:(floor(Nv/8+1/16)*8)
    cop(i)=i-8;
end
for i=(Nv+Np+9):(Nv+Np+floor(Nr/8+1/16)*8)
    cop(i)=i-8;
end
for i=N:-1:(1+Nv+Np+floor(Nr/8+1/16)*8)
    cop(i)=i-N+(Nv+Np+floor(Nr/8+1/16)*8);
end
rcop=cop;
rcop(3)=1;
rcop(4)=2;
rcop(Nv+3)=1;
rcop(Nv+4)=2;
rcop(Nv+Np+3)=1;
rcop(Nv+Np+4)=2;
% melody preference
pref=zeros(2,N); % Line 1 start, Line 2 end
pref(1,1:Nv)=zeros(1,Nv)+8;
pref(1,(Nv+1):(Nv+Np))=zeros(1,Np)+13;
pref(1,(Nv+Np+1):N)=zeros(1,Nr)+20;
pref(2,:)=pref(1,:)+12;
rpref=zeros(1,N); % rhythm preference
rpref(1:Nv)=zeros(1,Nv)+rpref_ratev;
rpref((Nv+1):(Nv+Np))=zeros(1,Np)+rpref_ratep;
rpref((Nv+Np+1):N)=zeros(1,Nr)+rpref_rater;
% hard limit
hl_r=zeros(1,N);
hl_r(N)=128; % only the first note
hl_c=zeros(1,N);
hl_c(1)=1; % all C chord
hl_c(Nv+Np+1)=1;
hl_c(N)=1;
%
yr=rnn_gen_r(N,alp,r_cop_rate,rcop,rpref,hl_r);
yc=rnn_gen_c(N,alp,c_cop_rate,cop,hl_c);
Nm=sum(sum(yr));
[yc0,yc1,yc2]=mk_yc(Nm,yc,yr);
[mcop,mpref]=mk_marr(Nm,yr,cop,pref);
hl_m=zeros(1,Nm);
hl_m(Nm)=25; %Force the last note to be c'
ym=rnn_gen_m(Nm,alp,m_cop_rate,mcop,pref_rate,mpref,hl_m,har_rate,yc2,nei_rate);
%
w=wws(1)*mk_wav(ym,yr,yc0,bpm,fs,cm_rate,dec_l,sm_l,f0);
for i=2:length(wws)
    w=w+wws(i)*mk_wav(ym,yr,yc0,bpm,fs,cm_rate,dec_l,sm_l,f0*i);
end
w=w/sum(wws);
audiowrite('test.wav',w,fs);