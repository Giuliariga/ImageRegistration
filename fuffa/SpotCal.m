function [annBlueVal,spotblueval]=spotCal(dry,col,center,rad,spotRect,n)
    

        spot=imcrop(col,spotRect);
        c = spotRect(1);
  	    r = spotRect(2);
        roOuter=rad*2;
        
        [rr,cc] = meshgrid(1:size(spot,1), 1:size(spot,2));
        Rs = (rr - center(2)).^2 + (cc - center(1)).^2 < (rad).^2;
        
        [rrW,ccW]= meshgrid(1:size(dry,1), 1:size(dry,2));
        centerW=spotRect(1:2)+center;
        
        
        
        Ran = ( (rrW - centerW(2)).^2 + (ccW - centerW(1)).^2 > (rad).^2 ) &...
            ( (rrW - centerW(2)).^2 + (ccW - centerW(1)).^2 < (roOuter).^2 );
     
        Rs=Rs';
        Ran=Ran';
   	    temp= spot.*Rs;
  	    Vs = temp( temp ~= 0);
        spotblueval = median(Vs);
%         figure(n);
%         imshow(temp);
        temp2 = col.*Ran;
        Van = temp2( temp2~= 0);
   	    annBlueVal= median(Van);
%         figure(n+1);
%         imshow(temp2);
        
       
  
  