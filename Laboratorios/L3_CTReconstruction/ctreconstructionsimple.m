%% Reconstruction from projections

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters
NumAngles = 8; % Number of sampled projecions
sizeimage = 128; %Image size (128) // 256
fsSpacign = 7; %Fourier Transform samples per pixel
halfcircle = 180; % Rotation degrees
photonCount = 1.0e3; % Photons that reached the detector (1000) // 1.0e4
attgain = 0.25;  % to change the attenuaiton coefficient
highdensityAtenuation = 0.1;

% Synthetic image (Phantom plus dots)
attgain = 50 * attgain/sizeimage;
f=abs(phantom(sizeimage));
% imshow(f,[])
f((f > 0.35) & (f < 0.45)) = highdensityAtenuation;
f = attgain*f;

figure(2)
subplot(2,3,4)
imshow(f,[0,attgain])
title('Original Phantom')

FF = fft2(f);
subplot(2,3,1)
imshow(log(abs(fftshift(FF))+1),[]);
title('Fourier Transform of Phantom')

%% Radon
% The projection angles and the radon transfrom
angles = linspace(0,halfcircle*(1.0-1.0/NumAngles),NumAngles);

rad = radon(f,angles);
rad = exp(-rad);
rad = double(uint16(poissrnd(photonCount*rad)));
rad(rad<1) = 0.5;
rad = -log(rad/photonCount);

subplot(2,3,2)
imshow(rad',[])
title('Radon Transform')

%% Inverse Radon Transform

rec = iradon(rad,angles,'linear');
rec1 = iradon(rad,angles,'linear','Ram-Lak');
rec2 = iradon(rad,angles,'linear','Shepp-Logan');
rec3 = iradon(rad,angles,'linear','Cosine');
rec4 = iradon(rad,angles,'linear','Hamming');
rec5 = iradon(rad,angles,'linear','Hann');
rec6 = iradon(rad,angles,'linear','None');

subplot(2,3,5)
imshow(rec,[0,attgain])
title('Filtered Back Projection')

%% Direct Fourier Reconstruction
szo = size(f);
srad = size(rad);
fff = complex(zeros(srad(1)));
sz = size(fff);

wts = zeros(sz(1));
shiftCorrection = exp(pi()*j*(srad(1)+1.0)/srad(1)*(1:srad(1)))';
n=1;
for i=angles
    %g = fft(rad(:,n));                      %not correct
    %g = fft(rad(:,n)).*shiftCorrection;     %not correct
    %g = fftshift(fft(rad(:,n)));            %not correct
    g = fftshift(fft(rad(:,n))) .* shiftCorrection; %the correct way
    sg = size(g);
    theta = i*pi()/180.0;
    sintheta = sin(theta);
    costheta = cos(theta);
    halfline = sg(1)/2.0 + 1.0;
    halfimage = round(sz(1)/2.0);
    sratio = sz(1)/sg(1);
    for an=0:(fsSpacign*sg(1)+1)
        fidx = (an+0.5)/fsSpacign;
        r = sratio*(fidx - halfline);
        xr = r*costheta;
        yr = r*sintheta;
        col = floor(xr+0.5) + halfimage;
        row = halfimage - floor(yr+0.5);
        gidx = floor(fidx);
        if ((row <= sz(1)) && (row > 0) && (col <= sz(1)) && (col > 0) && (gidx > 0) && (gidx <= sg(1)) )
            w1 = exp(-((round(xr)-xr)^2+(round(yr)-yr)^2)/0.5);
            fff(row,col) = fff(row,col) + w1*g(gidx);
            wts(row,col) = wts(row,col) + w1;
        end
    end    
    n = n + 1;
end
fff(wts>0) = fff(wts>0)./wts(wts>0);
subplot(2,3,3)
imshow(log(abs(fff)+1),[])
title('Sampled Fourier')
phaseCorrection = exp(-pi()*1i*(1:sz(1)))';
phaseCorrection = phaseCorrection.*phaseCorrection';
%frec = abs((ifft2(fff))); %This is not correct
frec = abs((ifft2(fff .* phaseCorrection))); %The correct way
deltacrop = round((sz(1)-szo(1))/2);
frec = frec(deltacrop:(sz(1)-deltacrop),deltacrop:(sz(1)-deltacrop));

subplot(2,3,6)
imshow(frec,[0,attgain]);
title('Direct Fourier Reconstruction')

%%

figure(3)
subplot(231)
imshow(rec1,[0,attgain])
title("Ram-Lak")
subplot(232)
imshow(rec2,[0,attgain])
title("Shepp-Logan")
subplot(233)
imshow(rec3,[0,attgain])
title("Cosine")
subplot(234)
imshow(rec4,[0,attgain])
title("Hamming")
subplot(235)
imshow(rec5,[0,attgain])
title("Hann")
subplot(236)
imshow(rec6,[0,attgain])
title("None")

figure(4)
subplot(231)
mesh(rec1)
title("Ram-Lak")
subplot(232)
mesh(rec2)
title("Shepp-Logan")
subplot(233)
mesh(rec3)
title("Cosine")
subplot(234)
mesh(rec4)
title("Hamming")
subplot(235)
mesh(rec5)
title("Hann")
subplot(236)
mesh(rec6)
title("None")