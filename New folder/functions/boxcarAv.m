%%==================================================================
%%boxcar averaging
%%%this function average each image starting from the beginning of the
%%%vector for the subsequent four, moving of one image each time. The last
%%%image are averaged for a decreasing number of images, till arriving to
%%%the last one that is left unalterated. 

function [out]=boxcarAv(Y) 
w=5;
l=length(Y(1,1,:));
  for i=1:l-w+1
   for z=i:i+w-2
       if z==i
       Yint=Y(:,:,z)+Y(:,:,z+1);
       else
           Yint=Yint+Y(:,:,z+1);
       end
   end 
   Yav(:,:,i)= Yint/w;
  end

j=l-w+2;
for k=j:l-1
    for x=k:l-1
        if x==k
            Yp=Y(:,:,x)+Y(:,:,x+1);
        else 
            Yp=Yp(:,:,1)+Y(:,:,x+1);
        end 
    end
    vet=k:l;
    len=length(vet);
    Yavl(:,:,k-j+1)=Yp/len;
end

  p=length(Yavl(1,1,:));
  Yavl(:,:,p+1)=Y(:,:,l);
  ll=length(Yav(1,1,:));
  lll=length(Yavl(1,1,:));
  out(:,:,1:ll)=Yav;
  out(:,:,ll+1:lll+ll)=Yavl;
  out=out;