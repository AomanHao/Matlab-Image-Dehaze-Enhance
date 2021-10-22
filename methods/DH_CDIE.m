function  output = DH_CDIE(input)

HSV = rgb2hsv(input);
H=HSV(:,:,1);
S=HSV(:,:,2);
V=HSV(:,:,3);
output = HSV;
output(:,:,3) =dehazing_CDIE_divChannel(V,5,10,0.8,[3 1 1/2],[85 170]);