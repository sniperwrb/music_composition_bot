function y=rnn_gen_r(N,alp,cop_r,cop,pref,hl)
    load res_r
    load ctrans
    xt=zeros(k,N);
    yt=zeros(k,N);
    pt=zeros(k,N);
    ht=zeros(H,N);
    htemp=zeros(H,1)+(1/H);
    x=zeros(k,1);
    k1=log2(k);
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
        p=p/sum(p);
        pt(:,i)=p;
        p1=rtr'*p; % 8 bit binary code
        
        if (cop(i)>0)
            p_cop=rtr'*ot(:,cop(i));
        else
            p_cop=zeros(k1,1)+0.5;
        end
        for j=1:k1
            pl=1-p1(j);
            pr=p1(j);
            pr=pr*pref(i);
            if (p_cop(j)==0)
                pl=pl*cop_r;
            end
            if (p_cop(j)==1)
                pr=pr*cop_r;
            end
            p1(j)=pr/(pl+pr);
        end
        
        r=rand(k1,1);
        pp=(r<p1)+0;
        q=(2.^(k1-1:-1:0))*pp;
        if (q==0)
            q=2^k1;
        end
        if (hl(i)>0)
            q=hl(i);
        end
        dt(i)=q;
        x=zeros(k,1);
        x(q)=1;
        ot(:,i)=x;
    end
    y=rtr'*ot;
end