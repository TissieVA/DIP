im_liver = imread('liver.jpg');
[bw1, h1] = detect(im_liver);

im_cystes = imread('liver_cyste.jpg');
[bw2, h2] = detect(im_cystes);

im_metastase = imread('liver_metastase.jpg');
[bw3, h3] = detect(im_metastase,3,3);

subplot(3,2,1); imshow(bw1);
subplot(3,2,2); imshow(h1);

subplot(3,2,3); imshow(bw2);
subplot(3,2,4); imshow(h2);

subplot(3,2,5); imshow(bw3);
subplot(3,2,6); imshow(h3);
