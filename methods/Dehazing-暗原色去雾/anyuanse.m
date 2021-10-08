function R = anyuanse(m_img)
% ԭʼͼ��
I=double(m_img)/255;

% ��ȡͼ���С
[h,w,c]=size(I);
win_size = 7;
img_size=w*h;
dehaze=zeros(img_size*c,1);
dehaze=reshape(dehaze,h,w,c);

win_dark=zeros(img_size ,1);

for cc=1:img_size
   win_dark(cc)=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
win_dark=reshape(win_dark,h,w);
%����ֿ����darkchannel
 for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        m_pos_min = min(I(i,j,:));
        for n=j-win_size:j+win_size    
            for m=i-win_size:i+win_size
                if(win_dark(m,n)>m_pos_min)
                    win_dark(m,n)=m_pos_min;
                end
            end
        end
       
    end
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
 %ͼ��͸����Ԥ�������ͼ����
 for cc=1:img_size
   win_dark(cc)=1-win_dark(cc);
 end
 %%%%%%%%%%%%%%%%%ͼ�����ͼ��ʼ%%%%%%%%%%%%%%%%%%%%%
 %ѡ����ȷdark value����
win_b = zeros(img_size,1);
 
for ci=1:h
    for cj=1:w
        if(rem(ci-8,15)<1)     %û��������
            if(rem(cj-8,15)<1)
                win_b(ci*w+cj)=win_dark(ci*w+cj);
            end
        end
       
    end
end
 
%��ʾ�ֿ�darkchannel
neb_size = 9;
win_size = 1;
epsilon = 0.0000001;
%ָ��������״
indsM=reshape([1:img_size],h,w);
%�������L
tlen = img_size*neb_size^2;
row_inds=zeros(tlen ,1);
col_inds=zeros(tlen,1);
vals=zeros(tlen,1);
len=0;
for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        if(rem(ci-8,15)<1)
            if(rem(cj-8,15)<1)
                continue;
            end
        end
      win_inds=indsM(i-win_size:i+win_size,j-win_size:j+win_size);
      win_inds=win_inds(:);%����ʾ
      winI=I(i-win_size:i+win_size,j-win_size:j+win_size,:);
      winI=reshape(winI,neb_size,c); %����ͨ������ƽ��Ϊһ����ά���� 3*9
      win_mu=mean(winI,1)';  %��ÿһ�еľ�ֵ ����ڶ�������Ϊ2 ��Ϊ��ÿһ�еľ�ֵ  //���������
      win_var=inv(winI'*winI/neb_size-win_mu*win_mu' +epsilon/neb_size*eye(c)); %�󷽲�

      winI=winI-repmat(win_mu',neb_size,1);%�����
      tvals=(1+winI*win_var*winI')/neb_size;% ��������ָ�ľ���L

      row_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds,1,neb_size),...
                                             neb_size^2,1);
      col_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds',neb_size,1),...
                                             neb_size^2,1);
      vals(1+len:neb_size^2+len)=tvals(:);
      len=len+neb_size^2;
    end
end 

 

vals=vals(1:len);
row_inds=row_inds(1:len);
col_inds=col_inds(1:len);
%����ϡ�����
A=sparse(row_inds,col_inds,vals,img_size,img_size);
%���е��ܺ� sumAΪ������
sumA=sum(A,2);
%spdiags(sumA(:),0,img_size,img_size) ����img_size��С��ϡ�������Ԫ����sumA�е���Ԫ�ط�����0ָ���ĶԽ���λ���ϡ�
A=spdiags(sumA(:),0,img_size,img_size)-A;


  %����ϡ�����
  D=spdiags(win_b(:),0,img_size,img_size);
  lambda=1;
  x=(A+lambda*D)\(lambda*win_b(:).*win_b(:));
  %%%%%%%%%%%%%%%%%%%%%%%%%��ͼ���ͼ����%%%%%%%%%%%%%%%55
 
   %ȥ��0-1��Χ�������
  alpha=max(min(reshape(x,h,w),1),0);%ͼ��͸����
 
A=220/255; %������û��ȥ����
%ȥ��
       
for i=1:c
    for j=1:h
        for l=1:w
            dehaze(j,l,i)=(I(j,l,i)-A)/alpha(j,l)+A;
        end
    end
end
R = dehaze;