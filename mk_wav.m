function w=mk_wav(ym,yr,yc,bpm,fs,wc_rate,dec_l,sm_l,f0)
    Nm=length(ym);
    N=size(yr);
    N1=N(1);
    Nr=N(2);
    Nc=Nr*2;
    wm=1/(1+wc_rate);
    wc=(1-wm)/3;
    wl=fs*(240/bpm)*Nr;
    ql=wl/Nc/4;
    pl0=fs*(240/bpm)/N1;
    w=zeros(wl,1);
    %cflist=f0*2.^([3:7,-4:2]/12);
    mflist=f0*2.^((-9:27)/12);
    dl=fs*(30/bpm)*dec_l;
    %dec=(dl:-1:1)/dl;
    dec=exp(-(1:4*dl)/dl);
    dl=dl*4;
    dec_c=repmat(dec(1:4*ql),4,1);
    sl=floor(fs*(30/bpm)*sm_l+0.5);
    for i=1:4
        dec_c(i,1:sl)=dec_c(i,1:sl).*((1:sl)/sl);
        dec_c(i,(ql*i-sl+1):ql*i)=dec_c(i,(ql*i-sl+1):ql*i).*((sl:-1:1)/sl);
    end
    %dec_c(4,:)=dec_c(4,:)/2;
    load ctrans
    for i=1:Nc
        for j=4:-1:1
            if (yc(i)>0)
                mi=mod(i,2);
                jj=j;
                if (mi==1)
                    jj=5-j;
                end
                if ((yr((1-mi)*4+(5-j),ceil(i/2))==0)||((mi==1)&&(j==4)))
                    q=sin((0:(ql*j-1))*(2*pi*f0*2^(ctrx(jj,yc(i))/12)/fs));
                    q=(q*(7-jj)/6).*dec_c(j,1:ql*j);
                    w(((i*4-j)*ql+1):(i*4*ql))=w(((i*4-j)*ql+1):(i*4*ql))+q';
                end
            end
        end
    end
    w=w*wc;
    s=Nr;t=N1;u=s*t;v=u;
    for i=Nm:-1:1
        while (yr(t,s)==0)
            t=t-1;
            if (t<=0)
                t=N1;s=s-1;
            end
        end
        u=(s-1)*N1+t;
        pl=(v-u+1)*pl0;
        p=sin((0:(pl-1))*(2*pi*mflist(ym(i))/fs));
        if (pl<=dl)
            p=p.*dec(1:pl);
        else
            p(1:dl)=p(1:dl).*dec;
            p(dl+1:pl)=p(dl+1:pl)*0;
        end
        p(1:sl)=p(1:sl).*((1:sl)/sl);
        p((pl-sl+1):pl)=p((pl-sl+1):pl).*((sl:-1:1)/sl);    
        w(((u-1)*pl0+1):(v*pl0))=w(((u-1)*pl0+1):(v*pl0))+wm*p';
        v=u-1;
        t=t-1;
        if (t<=0)
            t=N1;s=s-1;
        end
    end
end