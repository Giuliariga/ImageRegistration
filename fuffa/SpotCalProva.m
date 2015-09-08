function []=spotCalProva(dry,col,center,rad,spotRect,n)
    
        spot=imcrop(dry,spotRect);
        c = spotRect(1);
  	    r = spotRect(2);
        roOuter=rad*2;
        center=center+spotRect(1:2);
        
        [rr,cc]= meshgrid(1:size(col,1), 1:size(col,2));
        Rs = (rr - center(2)).^2 + (cc - center(1)).^2 < (rad).^2;
        Ran = ( (rr - center(2)).^2 + (cc - center(1)).^2 > (rad).^2 ) &...
            ( (rr - center(2)).^2 + (cc - center(1)).^2 < (roOuter).^2 );
     
        Rs=Rs';
        Ran=Ran';
   	    temp= col.*Rs;
  	    Vs = temp( temp ~= 0);
        spotblueval = median(Vs);
        figure(n);
        imshow(temp);
        temp2 = col.*Ran;
        Van = temp2( temp2~= 0);
   	    annBlueVal= median(Van);
        figure(n+1);
        imshow(temp2);
%         
       
  
  