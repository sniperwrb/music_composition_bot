ctr0=zeros(24,12);
for i=1:12
    ctr0(i,i)=1;
    ctr0(i,mod(i+6,12)+1)=1;
    ctr0(i,mod(i+3,12)+1)=1;
    ctr0(i+12,i)=1;
    ctr0(i+12,mod(i+6,12)+1)=1;
    ctr0(i+12,mod(i+2,12)+1)=1;
end

rtr=zeros(256,8);
for i=1:256
    for j=1:8
        if (mod(i,2^(9-j))>=2^(8-j))
            rtr(i,j)=1;
        end
    end
end

% C G F Am Em Dm E A
ctr=ctr0([1,8,6,22,17,15,5,10],:);
ctr=ctr';

save('ctrans.mat','ctr0','rtr','ctr');
