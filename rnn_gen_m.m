function y=rnn_gen_m(N,alp,cop_r,cop,pref_r,pref,hl,har_r,yc,nei_r)
    load res_m
    load ctrans
    xt=zeros(k,N);
    yt=zeros(k,N);
    pt=zeros(k,N);
    ht=zeros(H,N);
    htemp=zeros(H,1)+(1/H);
    x=zeros(k,1);
    x(13)=1;
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
        p=p.*([yc(:,i);yc(:,i);yc(:,i);yc(1,i)]*(har_r-1)+1);
        p(pref(1,i):pref(2,i))=p(pref(1,i):pref(2,i))*pref_r;
        if (cop(i)>0)
            p(dt(cop(i)))=p(dt(cop(i)))*cop_r;
        end
        if (i>1)
            q1=max(dt(i-1)-2,1);
            q2=min(dt(i-1)+2,37);
            p(q1:q1+1)=p(q1:q1+1)*nei_r;
            p(q2-1:q2)=p(q2-1:q2)*nei_r;
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