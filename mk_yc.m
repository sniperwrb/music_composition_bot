function [yc0,yc1,yc2]=mk_yc(Nm,yc,yr)
    N=length(yc);
    Nc=N*2;
    load ctrans
    yc1=zeros(12,Nc);
    yc0=zeros(1,Nc);
    for i=1:N
        if (yc(i)<=64)
            p=ceil(yc(i)/8);
            q=mod(yc(i)-1,8)+1;
            yc0(:,i*2-1)=p;
            yc0(:,i*2)=q;
            yc1(:,i*2-1)=ctr(:,p);
            yc1(:,i*2)=ctr(:,q);
        else
            yc1(:,i*2-1)=yc1(:,i*2-1)+1/4;
            yc1(:,i*2)=yc1(:,i*2)+1/4;
        end
    end
    yc2=zeros(12,Nm);
    p=1;
    q=1;
    for i=1:Nm
        while (yr(q,p)==0)
            q=q+1;
            if (q>8)
                q=1;
                p=p+1;
            end
        end
        yc2(:,i)=yc1(:,floor(p*2+q/4-1.125));
        q=q+1;
        if (q>8)
            q=1;
            p=p+1;
        end
    end
    yc1=floor(yc1);
end