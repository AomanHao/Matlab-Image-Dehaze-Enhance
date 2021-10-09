function result = enhazing_CLAHE(input,conf)

switch conf.clahe_color_mode
    case 'rgb'
        %% CLAHE的RGB版本
        rinput = input(:,:,1);
        ginput = input(:,:,2);
        binput = input(:,:,3);
        resultr = adapthisteq(rinput);
        resultg = adapthisteq(ginput);
        resultb = adapthisteq(binput);
        result = cat(3, resultr, resultg, resultb);
        %         imwrite(result,'CLAHE.jpg');
    case 'lab'
        %% CLAHE中对LAB的L通道的处理
        cform2lab=makecform('srgb2lab');
        LAB=applycform(input,cform2lab);
        L=LAB(:,:,1);
        LAB(:,:,1)=adapthisteq(L);
        cform2srgb=makecform('lab2srgb');
        result=applycform(LAB,cform2srgb);
        %         imwrite(result,'CLAHE.jpg');
end

