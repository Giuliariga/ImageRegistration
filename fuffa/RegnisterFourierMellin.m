
% It isn't sub-pixel accurate, although I'm aware of methods to achieve
% this by extracting the peaks around the peak of the phase correlation and
% finding the maxima (least squares perhaps).  
% I'd like to thank Adam for publishing his version.  Without it I'd never
% have known I had to take the log polar transform of the magnitude of the
% FFT, rather than the log polar transform of the original image!

function [Tx,Ty,Theta]=RegisterFourierMellin(I1,I2)

    % The procedure is as follows (note this does not compute scale)

    % (1)   Read in I1 - the image to register against
    % (2)   Read in I2 - the image to register
    % (3)   Take the FFT of I1, shifting it to center on zero frequency
    % (4)   Take the FFT of I2, shifting it to center on zero frequency
    % (5)   Convolve the magnitude of (3) with a high pass filter
    % (6)   Convolve the magnitude of (4) with a high pass filter
    % (7)   Transform (5) into log polar space
    % (8)   Transform (6) into log polar space
    % (9)   Take the FFT of (7)
    % (10)  Take the FFT of (8)
    % (11)  Compute phase correlation of (9) and (10)
    % (12)  Find the location (x,y) in (11) of the peak of the phase correlation
    % (13)  Compute angle (360 / Image Y Size) * y from (12)
    % (14)  Rotate the image from (2) by - angle from (13)
    % (15)  Rotate the image from (2) by - angle + 180 from (13)
    % (16)  Take the FFT of (14)
    % (17)  Take the FFT of (15)
    % (18)  Compute phase correlation of (3) and (16)
    % (19)  Compute phase correlation of (3) and (17)
    % (20)  Find the location (x,y) in (18) of the peak of the phase correlation
    % (21)  Find the location (x,y) in (19) of the peak of the phase correlation
    % (22)  If phase peak in (20) > phase peak in (21), (y,x) from (20) is the translation
    % (23a) Else (y,x) from (21) is the translation and also:
    % (23b) If the angle from (13) < 180, add 180 to it, else subtract 180 from it.
    % (24)  Tada!

    
    % Load first image (I1)
    I1 = imread('lena.bmp');
    % Load second image (I2)

    I2 = imread('lena_cropped_rotated_shifted.bmp');
    % Convert both to FFT, centering on zero frequency component
    
    SizeX = size(I1, 1);
    SizeY = size(I1, 2);
    
    FA = fftshift(fft2(I1));
    FB = fftshift(fft2(I2));
    
    % Convolve the magnitude of the FFT with a high pass filter
    
    IA = hipass_filter(size(I1, 1),size(I1,2)).*abs(FA);  
    IB = hipass_filter(size(I2, 1),size(I2,2)).*abs(FB);  
             
    % Transform the high passed FFT phase to Log Polar space
    
    L1 = transformImage(IA, SizeX, SizeY, SizeX, SizeY, 'nearest', size(IA) / 2, 'valid');
    L2 = transformImage(IB, SizeX, SizeY, SizeX, SizeY, 'nearest', size(IB) / 2, 'valid');
        
    % Convert log polar magnitude spectrum to FFT
    
    THETA_F1 = fft2(L1);
    THETA_F2 = fft2(L2);
   
    % Compute cross power spectrum of F1 and F2
    
    a1 = angle(THETA_F1);
    a2 = angle(THETA_F2);

    THETA_CROSS = exp(i * (a1 - a2));
    THETA_PHASE = real(ifft2(THETA_CROSS));

    % Find the peak of the phase correlation

    THETA_SORTED = sort(THETA_PHASE(:));  % TODO speed-up, we surely don't need to sort
    SI = length(THETA_SORTED):-1:(length(THETA_SORTED));
    [THETA_X, THETA_Y] = find(THETA_PHASE == THETA_SORTED(SI));
    
    
    % Compute angle of rotation
    DPP = 360 / size(THETA_PHASE, 2);
     Theta = DPP * (THETA_Y - 1);
 
    % Rotate image back by theta and theta + 180
    
    R1 = imrotate(I2, -Theta, 'nearest', 'crop');  
    R2 = imrotate(I2,-(Theta + 180), 'nearest', 'crop');
    
    % Output (R1, R2)
     
    % Take FFT of R1
     
    R1_F2 = fftshift(fft2(R1));
     
    % Compute cross power spectrum of R1_F2 and F2
    
    a1 = angle(FA);
    a2 = angle(R1_F2);

    R1_F2_CROSS = exp(i * (a1 - a2));
    R1_F2_PHASE = real(ifft2(R1_F2_CROSS));

    % Output (R1_F2_PHASE)    
    % Take FFT of R2
     
    R2_F2 = fftshift(fft2(R2));
     
    % Compute cross power spectrum of R2_F2 and F2
    
    a1 = angle(FA);
    a2 = angle(R2_F2);

    R2_F2_CROSS = exp(i * (a1 - a2));
    R2_F2_PHASE = real(ifft2(R2_F2_CROSS));

    % Output (R2_F2_PHASE)
    
  
    % Decide whether to flip 180 or -180 depending on which was the closest

    MAX_R1_F2 = max(max(R1_F2_PHASE));
    MAX_R2_F2 = max(max(R2_F2_PHASE));
    
    if (MAX_R1_F2 > MAX_R2_F2)
        
        [y, x] = find(R1_F2_PHASE == max(max(R1_F2_PHASE)));
        
        R = R1;
        
    else
        
        [y, x] = find(R2_F2_PHASE == max(max(R2_F2_PHASE)));
        
        if (Theta < 180)
            Theta = Theta + 180;
        else
            Theta = Theta - 180;
        end
        
        R = R2;
    end
    
    % Output (R, x, y)
    
    % Ensure correct translation by taking from correct edge
    
    Tx = x - 1;
    Ty = y - 1;
    
    if (x > (size(I1, 1) / 2))
        Tx = Tx - size(I1, 1);
    end
    
    if (y > (size(I1, 2) / 2))
        Ty = Ty - size(I1, 2);
    end
       
    % Output (Sx, Sy)
    
        