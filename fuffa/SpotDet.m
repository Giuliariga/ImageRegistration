%%This function provides for circle detection(thanks to the CircleDet
%%function

% 
function [annBlueVal,spotblueval]=spotCal(dry,col,center,rad,spotRect)
    

        spot=imcrop(col,spotRect);
        c = spotRect(1);
  	    r = spotRect(2);
        l1=spotRect(3);
        l2=spotRect(4);
        lm=max(l1,l2);
      
	    roOuter=lm/2;
    
        [rr,cc] = meshgrid(1:size(spot,1), 1:size(spot,2));
    
  	    Rs = (rr - center(2)).^2 + (cc - center(1)).^2 < (rad).^2;
        Ran = ( (rr - center(2)).^2 + (cc - center(1)).^2 > (rad).^2 ) &...
            ( (rr - center(2)).^2 + (cc - center(1)).^2 < (roOuter).^2 );
     
        Rs=Rs';
        Ran=Ran';
   	    temp= spot.*Rs;
  	    Vs = temp( temp ~= 0);
        spotblueval = median(Vs);
     
        temp = spot.*Ran;
        Van = temp( temp ~= 0);
   	    annBlueVal= median(Van);
     
       
  
  