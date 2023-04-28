%%

f=imread('SmallCandel.png');
candlesmall = imresize(f,0.25);
%imwrite(candlesmall,"SmallCandel.png","png")
figure(1)
imshow(f)
psf=fspecial("disk",32); %% esto es lpo wue cambia, [px]
figure(2)

imshow(psf,[])
g=conv2(double(f(:,:,3)),psf,"same");
figure(2)
imshow(g,[])

psf=fspecial("disk",5);
psfcol = conv2(psf,psf);
figure(3)
mesh(psfcol)

g=conv2(double(f(:,:,3)),psfcol,"same");
figure(4)
imshow(g,[])

figure(5)
sz = size(f);
mtf = abs(fft2(psf,sz(1),sz(2)));
%imshow(fftshift(mtf),[])
%mesh(fftshift(mtf))
%figure(6)
plot(mtf(1:sz/2,1))

%%
f=imread('SmallCandel.png');
candlesmall = imresize(f,0.25);

figure
% subplot(2,4,[1 5])
% imshow(f)
psf=fspecial("disk",15.554);
subplot(242)
imshow(psf,[])
g=conv2(double(f(:,:,3)),psf,"same");
subplot(243)
imshow(g,[])

subplot(244)
sz = size(f);
mtf = abs(fft2(psf,sz(1),sz(2)));
plot(mtf(1:sz/2,1))
axis([0 357,0 1])
grid on

psf=fspecial("disk",31.354);
psfcol = conv2(psf,psf);
subplot(246)
mesh(psfcol)

g=conv2(double(f(:,:,3)),psfcol,"same");
subplot(247)
imshow(g,[])

subplot(248)
mtfcol = abs(fft2(psfcol,sz(1),sz(2)));
plot(mtfcol(1:sz/2,1))
axis([0 357,0 1])
grid on
%%
f=imread('SmallCandel.png');
candlesmall = imresize(f,0.25);

figure
imshow(f)
title("Imagen Original")

figure
%psf=fspecial("disk",9.450);
psf=fspecial("disk",11.2);
subplot(231)
imshow(psf,[])
title("Cámara Estenopeica - PSF")

g=conv2(double(f(:,:,3)),psf,"same");
subplot(232)
imshow(g,[])
title("Cámara Estenopeica - Imagen Obtenida")

subplot(233)
sz = size(f);
mtf = abs(fft2(psf,sz(1),sz(2)));
plot(mtf(1:sz/2,1))
title("Cámara Estenopeica - MTF")
axis([0 357,0 1])
grid on

%psf=fspecial("disk",31.354);
psf=fspecial("disk",39.556);
psfcol = conv2(psf,psf);
subplot(234)
mesh(psfcol)
title("Cámara con Colimador - PSF")

g=conv2(double(f(:,:,3)),psfcol,"same");
subplot(235)
imshow(g,[])
title("Cámara con Colimador - Imagen Obtenida")

subplot(236)
mtfcol = abs(fft2(psfcol,sz(1),sz(2)));
plot(mtfcol(1:sz/2,1))
title("Cámara con Colimador - MTF")
axis([0 357,0 1])
grid on