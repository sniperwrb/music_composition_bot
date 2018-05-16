function [mcop,mpref]=mk_marr(Nm,yr,cop,pref)
    mcop=zeros(1,Nm);
    mpref=zeros(2,Nm);
    rs=size(yr);rx=rs(1);ry=rs(2);
    m0=zeros(rx,ry);
    mp=0;
    for j=1:ry
        for i=1:rx
            if (yr(i,j)==1)
                mp=mp+1;
                mpref(:,mp)=pref(:,j);
            end
            m0(i,j)=mp;
            if ((cop(j)>0)&&(mp>0))
                mcop(mp)=m0(i,cop(j));
            end
        end
    end
    
end