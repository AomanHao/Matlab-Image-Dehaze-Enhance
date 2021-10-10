function output = enhazing_HE(input)
%% 直方图均衡

HSI_f = rgb2hsi(uint8(input));
H=HSI_f(:,:,1);
S=HSI_f(:,:,2);
I=HSI_f(:,:,3);

%% 灰度直方图均衡
IE = histeq(I);

RV = cat(3,H,S,IE);
output = hsi2rgb(RV);