function [ C ] = getChrom( I )
    if ~isa(I, 'double')
        I = double(I)/255.0;
    end
    intensity = sqrt(max(sum(I.*I, 3), 0.1^10));
    C = zeros(size(I));
    C(:,:,1) = I(:,:,1)./intensity;
    C(:,:,2) = I(:,:,2)./intensity;
    C(:,:,3) = I(:,:,3)./intensity;
end
