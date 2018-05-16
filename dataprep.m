function dataprep(fimin,fimax)
    if (nargin<2)
        fimax=fimin;
        fimin=1;
    end

    kr=256; % rhythm 8 beats per bar 256 possible situations
    km=37; % for melody, one note = 1 entry
    kc=65; % 8 possible chords. give kc=x^2+1.
    % C G F Am Em Dm E A
    clist=[1 0 0 0 7 3 0 2 0 8 0 0 0 0 6 0 5 0 0 0 0 4 0 0];

    load ctrans
    for fi=fimin:fimax
        fn=[num2str(floor(fi/10)),num2str(mod(fi,10))];
        fid=fopen(['data\',fn,'.txt']);
        a=textscan(fid,'%s');
        fclose(fid);
        a=a{1};
        Nr=str2double(a{2})+str2double(a{3})+str2double(a{4});
        % verse + prechorus + refrain
        Nc=Nr;
        lb=str2double(a{6}); % length of biases
        biases=zeros(lb,3); % pitch_over_C start_bar end_bar
        for i=1:lb
            for j=1:3
                biases(i,j)=str2double(a{3+i*3+j});
            end
        end
        a=a(8+lb*3:end);
        la=length(a);
        xr_raw=zeros(8,Nr);  %rhythm
        xm_raw=zeros(1,1);   %melody
        xc_raw=zeros(1,2*Nr);%chord
        pr=1;
        qr=1;
        pm=0;
        pb=1;
        pc=0;
        f=0;
        for i=1:la
            ch=a{i};
            lc=length(ch);
            if (qr<=0)
                qr=qr+1;
                pc=pc+1;
                if (strcmp(ch,'-'))
                    xc_raw(pc)=xc_raw(pc-1);
                else
                    v=str2double(ch);
                    sv=sign(v);
                    v=floor(12/7*abs(v)+1/14);
                    v=mod(v-biases(pb,1)-1,12)+1;
                    xc_raw(pc)=v+(1-sv)*6;
                end
                if (qr==1)
                    pr=pr+1;
                    if (pr>biases(pb,3))
                        pb=pb+1;
                    end
                end
                continue;
            end
            if (strcmp(ch,'|'))
                qr=-1;
                continue;
            end
            if (f==1)
                ch=ch(1:lc-1);
                f=0;
            end
            if (ch(1)=='[')
                ch=ch(2:lc);
                f=1;
            end
            if (qr==9)
                adgkjadg(akdjgadkg);
            end
            if (~strcmp(ch,'-'))
                pm=pm+1;
                v=str2double(ch);
                v=floor(12/7*v+1/14)+12;
                xm_raw(pm)=v-biases(pb,1);
                xr_raw(qr,pr)=1;
            end
            qr=qr+(1-f);
        end

        Nm=pm;
        xr=4*(rtr-0.5)*(xr_raw-0.5);
        xr=max(0,xr-7);
        xc=zeros(kc,Nc);
        for i=1:Nc
            q=clist(xc_raw(i*2-1));
            p=(q-1)*8;
            q=clist(xc_raw(i*2));
            p=p+q;
            if ((p<=0)||(q==0))
                p=kc;
            end
            xc(p,i)=1;
        end
        xm=zeros(km,Nm);
        for i=1:Nm
            xm(xm_raw(i),i)=1;
        end

        N=Nm;
        k=km;
        x=xm;
        save(['data\',fn,'_m.mat'],'N','k','x');
        N=Nc;
        k=kc;
        x=xc;
        save(['data\',fn,'_c.mat'],'N','k','x');
        N=Nr;
        k=kr;
        x=xr;
        save(['data\',fn,'_r.mat'],'N','k','x');
    end
end