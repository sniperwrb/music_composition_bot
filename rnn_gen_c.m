function y=rnn_gen_c(N,alp,cop_r,cop,hl)
    load res_c
    load ctrans
    xt=zeros(k,N);
    yt=zeros(k,N);
    pt=zeros(k,N);
    ht=zeros(H,N);
    htemp=zeros(H,1)+(1/H);
    x=zeros(k,1);
    x(1)=1;
    ot=zeros(k,N);
    dt=zeros(N,1);
    for i=1:N
        xt(:,i)=x;
        h=tanh(Whh*htemp+Whx*x+bh);
        ht(:,i)=h;
        y=Wyh*h+by;
        y=y-max(y);
        yt(:,i)=y;
        htemp=h;
        p=exp(alp*y);
        if (cop(i)>0)
            p(dt(cop(i)))=p(dt(cop(i)))*cop_r;
        end
        p=p/sum(p);
        pt(:,i)=p;
        r=rand;
        q=0;
        while (r>0)
            q=q+1;
            r=r-p(q);
        end
        if (hl(i)>0)
            q=hl(i);
        end
        dt(i)=q;
        x=zeros(k,1);
        x(q)=1;
        ot(:,i)=x;
    end
    y=dt;
end