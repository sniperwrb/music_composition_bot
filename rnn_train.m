function rnn_train(ch,alp,songs,epochs,H,lr,clip)
    % 'c'=chord  'm'=melody  'r'=rhythm
    f=0;
    if (length(songs)>1)
        f=1;
        songlist0=songs;
        songs=length(songs);
    end
    load(['data\01_',ch,'.mat']);

    n=0;
    Whh=randn(H)*(1/H);
    Whx=randn(H,k)*(1/H);
    Wyh=randn(k,H)*(1/H);
    bh=zeros(H,1);
    by=zeros(k,1);
    mWhh=zeros(size(Whh));
    mWhx=zeros(size(Whx));
    mWyh=zeros(size(Wyh));
    mbh=zeros(size(bh));
    mby=zeros(size(by));
    sloss=zeros(epochs*songs,1);

    for epoch=1:epochs
        songlist=randperm(songs);
        if (f==1)
            songlist=songlist0(songlist);
        end
        for song=songlist
            n=n+1;
            fn=[num2str(floor(song/10)),num2str(mod(song,10))];
            load(['data\',fn,'_',ch,'.mat']); % train the chords
            %forward
            loss=0;
            ys=zeros(k,N-1);
            ps=zeros(k,N-1);
            hs=zeros(H,N-1);
            h0=zeros(H,1)+(1/H); %or randn?
            htemp=h0;
            for i=1:N-1
                xx=x(:,i);
                h=tanh(Whh*htemp+Whx*xx+bh);
                hs(:,i)=h;
                y=Wyh*h+by;
                y=y-max(y);
                ys(:,i)=y;
                htemp=h;
                p=exp(alp*y);
                p=p/sum(p);
                loss=loss-sum(log(p(x(:,i+1)>0)));
                ps(:,i)=p;
            end
            %back
            dWhh=zeros(size(Whh));
            dWhx=zeros(size(Whx));
            dWyh=zeros(size(Wyh));
            dbh=zeros(size(bh));
            dby=zeros(size(by));
            dhtemp=zeros(size(h0));
            for i=N-1:-1:1 
                dy=ps(:,i)-x(:,i+1);
                h=hs(:,i);
                dWyh=dWyh+dy*h';
                dby=dby+dy;
                dh=Wyh'*dy+dhtemp;
                dhraw=(1-h.*h).*dh;
                dbh=dbh+dhraw;
                xx=x(:,i);
                dWhx=dWhx+dhraw*xx';
                if (i>1)
                    htemp=hs(:,i-1);
                else
                    htemp=h0;
                end
                dWhh=dWhh+dhraw*htemp';
                dhtemp=Whh'*dhraw;
            end
            dWhh=dWhh.*(abs(dWhh)<clip)+clip*(dWhh>=clip)-clip*(dWhh<=-clip);
            dWhx=dWhx.*(abs(dWhx)<clip)+clip*(dWhx>=clip)-clip*(dWhx<=-clip);
            dWyh=dWyh.*(abs(dWyh)<clip)+clip*(dWyh>=clip)-clip*(dWyh<=-clip);
            dbh=dbh.*(abs(dbh)<clip)+clip*(dbh>=clip)-clip*(dbh<=-clip);
            dby=dby.*(abs(dby)<clip)+clip*(dby>=clip)-clip*(dby<=-clip);
            %last
            sloss(n)=loss;
            mWhh=mWhh+dWhh.^2;
            mWhx=mWhx+dWhx.^2;
            mWyh=mWyh+dWyh.^2;
            mbh=mbh+dbh.^2;
            mby=mby+dby.^2;
            Whh=Whh-lr*dWhh./sqrt(mWhh+1e-8);
            Whx=Whx-lr*dWhx./sqrt(mWhx+1e-8);
            Wyh=Wyh-lr*dWyh./sqrt(mWyh+1e-8);
            bh=bh-lr*dbh./sqrt(mbh+1e-8);
            by=by-lr*dby./sqrt(mby+1e-8); 

            if (mod(n,10)==0)
                clc
                n
            end
        end
    end

    save(['res_',ch,'.mat'],'Whh','Whx','Wyh','bh','by','H','k');
    save(['resm_',ch,'.mat'],'mWhh','mWhx','mWyh','mbh','mby');
end