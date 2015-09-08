ind.x=zeros(row,col);
ind.y=zeros(row,col);
cInt=round(center);
range=round(mean(rad)*1.5);

for z=1:length(center);  
     xC=cInt(z,1);
     yC=cInt(z,2);
         for r=1:row
            for c=1:col
                x=coord.x(r,c);
                y=coord.y(r,c);
                if (xC<x+range&&xC>x-range&&yC<y+range&&yC>y-range)==1
                   flag(r,c,z)=1;
                else
                    flag(r,c,z)=0;
                end
           end
     end 
end
 
            