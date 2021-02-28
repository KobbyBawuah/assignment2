%Assign 2 
%Kwabena Gyasi Bawuah 
%101048814

%initiailizing the dimensions of our matrices, ensuring L is 3/2 times W
W = 100;
L = (3/2)*W;

G = sparse(L*W , L*W);
Op = zeros(L*W , 1);

%fill the g matrix
for i=1:L
    for j=1:W
        n= j + (i - 1) * W;
        nxms = j + (i-2) * W; 
        nxps = j + (i) * W;
        nyms = (j - 1) + (i - 1) * W;
        nyps = (j + 1)+(i - 1) * W;   
        if i == 1  %left edge
            G(n,n)=1;
            Op(n)=1;
        elseif i==L %right edge
            G(n,n)=1;
            Op(n)=1;
        elseif j==W %top edge
            G(n,n)=-3;
        elseif j==1 %bottom edge
            G(n,n)=-3;
        else   %inside parts
            G(n,n) = -4;
            G(n,nxms)= 1;
            G(n,nxps) = 1;
            G(n,nyms) = 1;
            G(n,nyps) = 1;
        end        
    end
end

Voltage = G\Op;

%surfed matrix (x,y,voltage)
sol = zeros(L,W);

for i = 1:L
    for j = 1:W
        n = j + (i-1)*W;
        sol(i,j) = Voltage(n);
    end  
end   

figure(1)
surf(sol)
colorbar
title("Voltage plot with Finite Difference in one dimension")
xlabel("X pos")
ylabel("Y pos")
zlabel("Voltage")
