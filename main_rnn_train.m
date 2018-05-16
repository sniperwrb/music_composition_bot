songs=17;
if (length(songs)==1)
    epochs=floor(1000/songs);
else
    epochs=floor(1000/length(songs));
end
alp=0.1;
H=100; %Hidden vector length
lr=0.1; %learning rate
clip=5;
rnn_train('m',alp,songs,epochs,H,lr,clip)
rnn_train('c',alp,songs,epochs,H,lr,clip)
rnn_train('r',alp,songs,epochs,H,lr,clip)

