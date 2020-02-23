function [AbsA, Absb] = AbsScaleConstraint (I, Luma)
    [h,w,~] = size(I);
    N = h * w;
    % find brightest pixel(s).
    BrightestPos = find(Luma > 0.99);   %0.999: 65pos; 0.99: 4355pos.
    % Num_brightest = size(BrightestPos, 1);
    Absb = zeros(N, 1);
    Absb(BrightestPos(:)) = 1;
    AbsA = sparse(1:N, 1:N, Absb, N, N);
 end