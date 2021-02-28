%Assign 2 
%Kwabena Gyasi Bawuah 
%101048814

%initiailizing the dimensions of our matrices, ensuring L is 3/2 times W
W = 50;
L = (3/2)*W;

G = sparse(L*W , L*W);
Op = zeros(L*W , 1);

%fill the g matrix
for i = 1:W
    for j = 1:L
        
        n = j + (i-1)*L;
        
        if i == 1  %left edge
            
            G(n,:) = 0;
            G(n,n) = 1;
            Op(n) = 1;
            
        elseif i == W %right edge
            
            G(n,:) = 0;
            G(n,n) = 1;
            Op(n) = 0;
            
        elseif j == 1 %bottom edge
            
            G(n, :) = 0;
            G(n, n) = -3;
            G(n, n+1) = 1;
            G(n, n+L) = 1;
            G(n, n-L) = 1;
      
        elseif j == L %top edge
        
            G(n, n) = -3;
            G(n, n-1) = 1;
            G(n, n+L) = 1;
            G(n, n-L) = 1;
            
        else   %inside parts
            
            G(n, n) = -4;
            G(n, n+1) = 1;
            G(n, n-1) = 1;
            G(n, n+L) = 1;
            G(n, n-L) = 1;
            
        end
    end
end

Voltage = G\Op;

%surfed matrix (x,y,voltage)
sol = zeros(W,L);

for i = 1:W
    for j = 1:L
        n = j + (i-1)*L;
        sol(i,j) = Voltage(n);
    end  
end   

figure(1)
surf(sol)
colorbar
title("Voltage plot with Finite Difference in 1D")
xlabel("X pos")
ylabel("Y pos")
zlabel("Voltage")
view(-130,30)
%the end
